---
title : "Tạo ECS Capacity"
menuTitle: "ECS Capacity"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre: "<b> 6.2. </b>"
description: "Tạo Capacity cho Amazon ECS, nơi mà các container của bạn chạy. Bao gồm tạo launch template, auto scaling group, và capacity provider."
---

## Tổng quan

{{% notice info %}}
Amazon ECS capacity là cơ sở hạ tầng nơi mà các container của bạn chạy. 
{{% /notice %}}

ECS capacity có 3 loại sau:
* Các instance Amazon EC2: Bạn chọn loại instance, số lượng instance và quản lý capacity.
* Serverless (AWS Fargate): Với Fargate, bạn không cần quản lý máy chủ, xử lý kế hoạch capacity, hoặc cách ly các công việc container để bảo mật.
* On-premise Máy ảo (VM) hoặc server: Amazon ECS Anywhere cung cấp hỗ trợ để đăng ký một instance bên ngoài như on-premises server hoặc virtual machine (VM), vào Amazon ECS cluster của bạn.

{{% notice warning %}}
**ECS cluster capacity providers** với **ECS capacity** không phải là một.   
***ECS capacity** đề cập đến khả năng cơ sở hạ tầng mà có sẵn để chạy các nhiệm vụ và dịch vụ trong một cluster ECS. Capacity này có thể được cung cấp bằng cách sử dụng các nhà cung cấp capacity.*    
***Capacity provider strategy** xác định cách các nhiệm vụ được phân phối đến các nguồn cơ sở hạ tầng khác nhau trong cluster. Điều này giúp tối ưu hóa việc sử dụng tài nguyên và chi phí dựa trên yêu cầu của task.* Mỗi cluster có một hoặc nhiều nhà capacity provider và một cấu hình capacity provider strategy mặc định tùy chọn. Capacity provider stratergy xác định cách các task được phân phối qua các capacity provider. Khi chạy một task hoặc tạo một service, bạn có thể sử dụng capacity provider stragtegy mặc định của cluster hoặc chỉ định một capacity provider stragtegy thay thế.
{{% /notice %}}

## Quy trình

1. Truy xuất ECS-optimized AMI

    ```shell
    # Get ECS AMI ID
    ecs_instance_ami_id=$(aws ssm get-parameters \
        --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
        --region $region | jq -r '.Parameters[0].Value | fromjson.image_id')
    ```

    Ở đây chúng ta sử dụng **Amazon Linux 2** làm hệ điều hành cơ sở, đối với các hệ điều hành cơ sở khác, tìm hiểu thông tin tại [Retrieving Amazon ECS-Optimized AMI metadata](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/retrieve-ecs-optimized_AMI.html)

2. Tạo Launch Template với Amazon ECS-optimized AMI

    ECS agent là một công cụ containerization mà ECS sử dụng để quản lý instance. Để ECS agent biết rằng Instance này thuộc về ECS Cluster nào, bạn phải cấu hình như sau trong tệp /etc/ecs/ecs.config
    
    ```shell
    ECS_CLUSTER=ecs_cluster_name
    ```

    ```shell
    ecs_instance_type=t3.medium
    ecs_instance_subnet_id=$subnet_public_1
    ecs_launch_template_name=$project-ecs-launch-template
    # Tạo Launch template file
    cat <<EOF | tee ecs-launch-template.json
    {
        "ImageId": "$ecs_instance_ami_id",
        "InstanceType": "$ecs_instance_type",
        "IamInstanceProfile": {
            "Arn": "$ecs_instance_profile_arn"
        },
        "NetworkInterfaces": [{
            "DeviceIndex": 0,
            "AssociatePublicIpAddress": true,
            "Groups": ["$ecs_instance_sgr_id"],
            "SubnetId": "$ecs_instance_subnet_id"
        }],
        "KeyName": "$ecs_instance_key_name",
        "TagSpecifications": [{
            "ResourceType": "instance",
            "Tags": `echo '['$tagspec | sed 's/{/{"/g; s/}/"}/g; s/,/","/g; s/}","{/},{/g; s/=/":"/g'`
        }],
        "UserData": "`cat <<EOF | openssl base64 -A
    #!/bin/bash
    echo ECS_CLUSTER=$ecs_cluster_name >> /etc/ecs/ecs.config
    EOF`"
    }
    EOF
    # Tạo launch template sử dụng file launch template vừa tạo
    aws ec2 create-launch-template \
        --launch-template-name $ecs_launch_template_name \
        --launch-template-data file://ecs-launch-template.json
    ```
   
3. Tạo Auto Scaling Group sử dụng template vừa tạo

    ```shell
    ecs_instance_name=$project-ecs-instance
    ecs_autoscaling_group_name=$project-ecs-autoscaling-group
    # create Autoscaling group
    aws autoscaling create-auto-scaling-group \
        --auto-scaling-group-name $ecs_autoscaling_group_name \
        --launch-template "$(echo "{\"LaunchTemplateName\":\"$ecs_launch_template_name\"}")" \
        --min-size 1 \
        --max-size 3 \
        --desired-capacity 1 \
        --tags "$(echo $tags | jq -c '. + [{"Key":"Name","Value":"'"$ecs_instance_name"'"}]')"


    ecs_autoscaling_group_arn=$(aws autoscaling describe-auto-scaling-groups \
        --auto-scaling-group-names $ecs_autoscaling_group_name \
        | jq .AutoScalingGroups[0].AutoScalingGroupARN)
    ```

4. List Container Instance

    Kiểm tra các instance trong autoscaling group đã thuộc ECS quản lý chưa

    ```shell
    aws ecs list-container-instances --cluster $ecs_cluster_name
    ```

5. Tạo Capacity Provider và sử dụng cho ECS Cluster

    Thật ra trong bài lab này tạo ECS Capacity Provider không ý nghĩa lắm. Chủ yếu để biết và hiểu cách tạo ECS Capacity Provider. (Bỏ phần này Lab vẫn hoạt động 🥲)

    ```shell
    ecs_capacity_provider=$project-capacity-provider
    # Tạo Capacity provider
    aws ecs create-capacity-provider \
        --name $ecs_capacity_provider \
        --auto-scaling-group-provider `echo "autoScalingGroupArn=$ecs_ec2_autoscaling_arn,managedScaling={status=ENABLED,targetCapacity=100},managedTerminationProtection=DISABLED"` \
        --tags $tags2

        aws ecs put-cluster-capacity-providers \
            --cluster $ecs_cluster_name \
            --capacity-providers $ecs_capacity_provider \
            --default-capacity-provider-strategy capacityProvider=$ecs_capacity_provider,weight=1
    ```

## Thực hiện

1. Lấy giá trị ECS-optimized AMI
    
    ![Retrieve ECS-optimized AMI](/images/6-ecs/6.2-capacity/6.2.1.png)

2. Tạo Launch Template

    Tạo nội dung cho file cấu hình Launch Template
    
    ![Create Launch Template file](/images/6-ecs/6.2-capacity/6.2.2.png)

    Nội dung file cấu hình và sử dụng nó để tạo Launch Template

    ![Create Launch Template](/images/6-ecs/6.2-capacity/6.2.3.png)

    Tạo Launch Template thành công:

    ![Created Launch Template](/images/6-ecs/6.2-capacity/6.2.4.png)
  
3. Tạo Auto Scaling Group sử dụng template vừa tạo

    ![Create Auto Scaling Group](/images/6-ecs/6.2-capacity/6.2.5.png)

    Kiểm tra kết quả bằng AWS Console

    ![Created Auto Scaling Group](/images/6-ecs/6.2-capacity/6.2.6.png)
    
4. List Container Instance

    ![List Container instance of ECS Cluster](/images/6-ecs/6.2-capacity/6.2.7.png)

5. Tạo Capacity Provider và sử dụng cho ECS Cluster

    ![Create Capacity Provider](/images/6-ecs/6.2-capacity/6.2.8.png)

    Kiểm tra kết quả bằng AWS Console

    ![Created Capacity Provider](/images/6-ecs/6.2-capacity/6.2.9.png)

## Tham khảo

| 👉 Tạo sao có Auto Scaling Group rồi mà vẫn cần phải sử dụng Capacity Provider?   
Your auto scaling group scaling works on a service level only. An ECS cluster can have many services running. Therefore, capacity provider runs at cluster level and can scale your container instances based on all the services in the cluster, not only one service.   
Câu trả lời của anh khá uy tín về AWS trên StackOverFlow [Whats the difference on using a ECS capacity provider and using automatic scaling from auto scaling group in a ECS cluster?](https://stackoverflow.com/questions/67398134/whats-the-difference-on-using-a-ecs-capacity-provider-and-using-automatic-scalin)

Document của AWS có viết về phần này [Creating a cluster with an EC2 task using the AWS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_EC2.html)

https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html