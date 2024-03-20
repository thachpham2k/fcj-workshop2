---
title : "Creating ECS Capacity for Elastic Container Service (ECS)"
menuTitle: "ECS Capacity"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre: "<b> 6.2. </b>"
description: "Create Capacity for Amazon ECS, where your containers run. Includes creating launch template, auto scaling group, and capacity provider."
---

## Overview

{{% notice info %}}
Amazon ECS capacity is the infrastructure where your containers run.
{{% /notice %}}

The following is an overview of the capacity options:
* Amazon EC2 instances in the AWS cloud: You choose the instance type, the number of instances, and manage the capacity.
* Serverless (AWS Fargate) in the AWS cloud: Fargate is a serverless, pay-as-you-go compute engine. With Fargate, you don't need to manage servers, handle capacity planning, or isolate container workloads for security.
* On-premises virtual machines (VM) or servers: Amazon ECS Anywhere provides support for registering an external instance such as an on-premises server or virtual machine (VM), to your Amazon ECS cluster.

{{% notice warning %}}
**ECS cluster capacity providers** and **ECS capacity** are not the same.   
***ECS capacity** is referring to the infrastructure capacity that is available to run tasks and services within an ECS cluster. This capacity can be provisioned using capacity providers.*   
***The capacity provider** strategy then determines how tasks get distributed to the different infrastructure sources within the cluster. This helps optimize resource usage and cost based on the task requirements.* Each cluster has one or more capacity providers and an optional default capacity provider strategy. The capacity provider strategy determines how the tasks are spread across the capacity providers. When you run a task or create a service, you may either use the cluster’s default capacity provider strategy or specify a capacity provider strategy that overrides the cluster’s default strategy.
{{% /notice %}}


## Steps

1. Retrieve ECS-optimized AMI

    ```shell
    # Get ECS AMI ID
    ecs_instance_ami_id=$(aws ssm get-parameters \
        --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
        --region $region | jq -r '.Parameters[0].Value | fromjson.image_id')
    ```

    Here we use **Amazon Linux 2** as the base operating system; for other base operating systems, refer to [Retrieving Amazon ECS-Optimized AMI metadata](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/retrieve-ecs-optimized_AMI.html)

2. Create Launch Template with Amazon ECS-optimized AMI

    The ECS agent is a containerization tool used by ECS to manage instances. To let the ECS agent know which cluster this instance belongs to, you need to configure the following in the /etc/ecs/ecs.config file:

    ```shell
    ECS_CLUSTER=ecs_cluster_name
    ```

    ```shell
    ecs_instance_type=t3.medium
    ecs_instance_subnet_id=$subnet_public_1
    ecs_launch_template_name=$project-ecs-launch-template
    # Create Launch template file
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
    # Create launch template using the created launch template file
    aws ec2 create-launch-template \
        --launch-template-name $ecs_launch_template_name \
        --launch-template-data file://ecs-launch-template.json
    ```
   
3. Create Auto Scaling Group using the template created

    ```shell
    ecs_instance_name=$project-ecs-instance
    ecs_autoscaling_group_name=$project-ecs-autoscaling-group
    # Create Autoscaling group
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

    Check instances in the autoscaling group if they are managed by ECS or not

    ```shell
    aws ecs list-container-instances --cluster $ecs_cluster_name
    ```

5. Create Capacity Provider and use it for ECS Cluster

    Actually, creating an ECS Capacity Provider in this lab doesn't make much sense. Mostly for educational purposes to know and understand how to create an ECS Capacity Provider. (This part can be skipped, and the lab will still function 🥲)

    ```shell
    ecs_capacity_provider=$project-capacity-provider
    # Create Capacity provider
    aws ecs create-capacity-provider \
        --name $ecs_capacity_provider \
        --auto-scaling-group-provider `echo "autoScalingGroupArn=$ecs_ec2_autoscaling_arn,managedScaling={status=ENABLED,targetCapacity=100},managedTerminationProtection=DISABLED"` \
        --tags $tags2

        aws ecs put-cluster-capacity-providers \
            --cluster $ecs_cluster_name \
            --capacity-providers $ecs_capacity_provider \
            --default-capacity-provider-strategy capacityProvider=$ecs_capacity_provider,weight=1
    ```

## Execution

1. Retrieve ECS-optimized AMI
    
    ![Retrieve ECS-optimized AMI](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.1.png)

2. Create Launch Template

    Create content for the Launch Template configuration file
    
    ![Create Launch Template file](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.2.png)

    Content of the configuration file and use it to create the Launch Template
    
    ![Create Launch Template](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.3.png)

    Successful creation of the Launch Template:

    ![Created Launch Template](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.4.png)
  
3. Create Auto Scaling Group using the created template

    ![Create Auto Scaling Group](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.5.png)

    Check the result on the AWS Console

    ![Created Auto Scaling Group](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.6.png)
    
4. List Container Instances

    ![List Container instance of ECS Cluster](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.7.png)

5. Create Capacity Provider and use it for ECS Cluster

    ![Create Capacity Provider](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.8.png)

    Check the result on the AWS Console

    ![Created Capacity Provider](/fcj-workshop2/images/6-ecs/6.2-capacity/6.2.9.png)

## References

| 👉 Why use Capacity Provider if you already have an Auto Scaling Group?   
Your auto scaling group scaling works on a service level only. An ECS cluster can have many services running. Therefore, capacity provider runs at cluster level and can scale your container instances based on all the services in the cluster, not only one service.   
A highly reliable answer on AWS from StackOverFlow [Whats the difference on using a ECS capacity provider and using automatic scaling from auto scaling group in a ECS cluster?](https://stackoverflow.com/questions/67398134/whats-the-difference-on-using-a-ecs-capacity-provider-and-using-automatic-scalin)

AWS documentation on this topic [Creating a cluster with an EC2 task using the AWS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_EC2.html)

https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html