---
title : "Create IAM Instance profile"
menuTitle : "IAM Instance profile"
date : "`r Sys.Date()`"
weight : 3
chapter : false
pre : " <b> 2.3. </b> "
description: "Create instance profile for AWS EC2"
---

## Overview

{{% notice info %}}
Use an instance profile to pass an IAM role to an EC2 instance.It allows EC2 Instances to access AWS services securely and securely without using traditional login credentials such as Access Key ID and Secret Access Key.
{{% /notice %}}

{{% notice note %}}
When you create an IAM role using the IAM console, the console creates an instance profile automatically and gives it the same name as the role to which it corresponds. If you use the Amazon EC2 console to launch an instance with an IAM role or to attach an IAM role to an instance, you choose the role based on a list of instance profile names.   
If you use the AWS CLI, API, or an AWS SDK to create a role, you create the role and instance profile as separate actions, with potentially different names. If you then use the AWS CLI, API, or an AWS SDK to launch an instance with an IAM role or to attach an IAM role to an instance, specify the instance profile name.   
{{% /notice %}}

## Steps to create an instance profile:

1. Create an IAM role and define which accounts or AWS services can assume the role.
 
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

2. Define which API actions and resources the application can use after assuming the role (Attach policy to IAM Role).

    ```shell
    aws iam attach-role-policy \
        --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
        --role-name $ecs_instance_role_name

    aws iam attach-role-policy \
        --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
        --role-name $ecs_instance_role_name
    ```

3. Create an IAM instance profile

    ```shell
    aws iam create-instance-profile \
        --instance-profile-name $ecs_instance_role_name
    ```

4. Add the Role just created to the Instance profile

    ```shell
    aws iam add-role-to-instance-profile \
        --instance-profile-name $ecs_instance_role_name \
        --role-name $ecs_instance_role_name
    ```
5. Retrieve Instance Profile information used for instances (EC2)

    ```shell
    ecs_instance_profile_arn=$(aws iam get-instance-profile \
        --instance-profile-name $ecs_instance_role_name \
        --output text \
        --query 'InstanceProfile.Arn')
    ```

## Execution

1. Create an IAM Role

    ![Created IAM Role](/images/2-prerequiste/2.3-iam/2.3.2-create-role.png)

2. Attach policies to the IAM Role

    ![Attach policy to IAM Role](/images/2-prerequiste/2.3-iam/2.3.3-attack-policy.png)

3. Create an IAM instance profile

   ![Create Instance Profile via CLI](/images/2-prerequiste/2.3-iam/2.3.4-create-profile.png)

4. Add the Role to the Instance profile

    ![Add Role to Instance Profile](/images/2-prerequiste/2.3-iam/2.3.5-add-role-2-profile.png)
    
    Access the IAM Role via the AWS Console, and for roles assigned to the instance profile, the **Instance profile ARN** will be displayed in the upper-right corner under the Summary section
    
    ![Created Instance Profile](/images/2-prerequiste/2.3-iam/2.3.7-iam-role.png)

5. Retrieve the Instance Profile information used for the instance (EC2)

    ![Get Instance Profile via CLI](/images/2-prerequiste/2.3-iam/2.3.6-profile-arn.png)

## References

To learn more about Instance Profile and IAM Role for EC2:
* [IAM roles for Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile)
* [Using instance profiles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html)
