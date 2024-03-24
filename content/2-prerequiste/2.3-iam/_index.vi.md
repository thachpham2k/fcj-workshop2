---
title : "Tạo IAM Instance profile"
menuTitle : "IAM Instance profile"
date : "`r Sys.Date()`"
weight : 3
chapter : false
pre : " <b> 2.3. </b> "
description: "Tạo instance profile cho AWS EC2"
---

## Tổng quan

{{% notice info %}}
AWS Instance Profile là một cách để gán IAM (Identity and Access Management) Role cho các EC2 Instances. Nó cho phép các EC2 Instances truy cập các dịch vụ AWS một cách an toàn và bảo mật, mà không cần sử dụng các thông tin đăng nhập truyền thống như Access Key ID và Secret Access Key.   
{{% /notice %}}

{{% notice note %}}
Khi tạo IAM Role cho EC2 sử dụng AWS console, một instance profile sẽ được tạo tự động và nó có tên giống như IAM role. Nếu cấu hình EC2 sử dụng AWS console thì bạn sẽ chọn IAM Role (hiển thị) thay vì IAM instance profile (nhưng vẫn danh sách role vẫn dựa trên danh sách instance profile).   
Nhưng nếu Sử dụng AWS CLI, API hoặc AWS SDK thì việc tạo IAM Role, Instance Profile là 2 quá trình riêng biệt. Nếu cấu hình IAM EC2 thì bạn sẽ chọn instance profile name.
{{% /notice %}}

## Quy Trình

Các bước để tạo 1 instance profile:

1. Tạo IAM Role với quyền được sử dụng bởi EC2.
 
    ```shell
    ecs_instance_role_name=$project-ecs-instance-role
    # Create EC2 Role
    aws iam create-role \
        --role-name $ecs_instance_role_name \
        --assume-role-policy-document '{
            "Version": "2012-10-17",
            "Statement": [{
                "Effect": "Allow",
                "Principal": {
                    "Service": ["ec2.amazonaws.com"]
                },
                "Action": ["sts:AssumeRole"]
            }]
        }' \
        --tags "$tags"
    ```

2. Xác định các API actions và resources mà Instance có thể sử dụng (Gán policy cho IAM Role)

    ```shell
    aws iam attach-role-policy \
        --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
        --role-name $ecs_instance_role_name

    aws iam attach-role-policy \
        --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
        --role-name $ecs_instance_role_name
    ```

3. Tạo IAM instance profile

    ```shell
    aws iam create-instance-profile \
        --instance-profile-name $ecs_instance_role_name
    ```

4. Thêm Role vừa được tạo vào Instance profile

    ```shell
    aws iam add-role-to-instance-profile \
        --instance-profile-name $ecs_instance_role_name \
        --role-name $ecs_instance_role_name
    ```

5. Lấy thông tin Instance Profile sử dụng cho instance (EC2)

    ```shell
    ecs_instance_profile_arn=$(aws iam get-instance-profile \
        --instance-profile-name $ecs_instance_role_name \
        --output text \
        --query 'InstanceProfile.Arn')
    ```

## Thực hiện

1. Tạo IAM Role với quyền được sử dụng bởi EC2.

    ![Created IAM Role](/images/2-prerequiste/2.3-iam/2.3.2-create-role.png)

2. Gán policy cho IAM Role

    ![Attack policy to IAM Role](/images/2-prerequiste/2.3-iam/2.3.3-attack-policy.png)

3. Tạo IAM instance profile

   ![Create Instance Profile via cli](/images/2-prerequiste/2.3-iam/2.3.4-create-profile.png)

4. Thêm Role vừa được tạo vào Instance profile

    ![Add Role to Instance Profile](/images/2-prerequiste/2.3-iam/2.3.5-add-role-2-profile.png)
    
    Truy cập IAM Role thông qua AWS Console, với những role được gán cho instance profile thì sẽ có **Instance profile ARN** ở góc bên phải phía trên thuộc phần Summary
    
    ![Created Instance Profile](/images/2-prerequiste/2.3-iam/2.3.7-iam-role.png)

5. Lấy thông tin Instance Profile sử dụng cho instance (EC2)

    ![Get Instance Profile via Cli](/images/2-prerequiste/2.3-iam/2.3.6-profile-arn.png)
    


## Tham khảo

Muốn tìm hiểu thêm về Instance Profile và IAM Role cho EC2:
* [IAM roles for Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile)
* [Using instance profiles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html)
