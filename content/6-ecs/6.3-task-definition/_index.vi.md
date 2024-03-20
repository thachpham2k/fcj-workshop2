---
title : "Tạo ECS Task Definition"
menuTitle: "Task Definition"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre: "<b> 6.3. </b>"
description: "Tạo Task Definition. Task Definition là một bản thiết kế cho ứng dụng của bạn. Đó là một tệp văn bản có định dạng JSON mô tả các tham số và một hoặc nhiều container tạo nên ứng dụng của bạn."
---

## Tổng quan

{{% notice info %}}
Task Definition là một bản thiết kế cho ứng dụng của bạn. Đó là một tệp văn bản có định dạng JSON mô tả các tham số và một hoặc nhiều container tạo nên ứng dụng của bạn.
{{% /notice %}}

## Quy trình

1. Tạo IAM Role cho Task Definition
   
   1. Tạo IAM Role cho Task Definition với quyền được sử dụng bởi `ecs-tasks.amazonaws.com`

        ```shell
        # Lấy ARN của AWS secret manager
        secret_arn=$(aws secretsmanager describe-secret --secret-id $secret_name --query 'ARN' --output text)
        # Tạo IAM Role cho Task Definition
        ecs_task_role_name=$project-ecs-task-role
        ecs_task_policy_name=${project}_ecs_task_policy
        ecs_task_name=$project-task
        ecs_task_uri=$ecr_image_uri
        # Tạo IAM Role
        ecs_task_role_arn=$(aws iam create-role \
            --role-name $ecs_task_role_name \
            --assume-role-policy-document '{
                "Version": "2012-10-17",
                "Statement": [{
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ecs-tasks.amazonaws.com"
                    },
                    "Action": ["sts:AssumeRole"]
                }]
            }' \
            --tags "$tags" \
            --output text \
            --query 'Role.Arn')

        echo ecs_task_role_arn=$ecs_task_role_arn
        ```

   2. Gắn các chính sách vào IAM Role này

        ```shell
        cat <<EOF | tee ecs-task-role.json
        {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "`echo $secret_arn`",
                "`echo $secret_arn`*"
            ]
            }
        ]
        }
        EOF

        aws iam put-role-policy \
            --role-name $ecs_task_role_name \
            --policy-name $ecs_task_policy_name \
            --policy-document file://ecs-task-role.json

        aws iam attach-role-policy \
            --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
            --role-name $ecs_task_role_name
        ```

2. Tạo Task Definition

    1. Tạo tệp định nghĩa Task definition
        
        Nội dung của SecretsManager tạo từ trước có dạng Json như sau 

        ```json
        {
            "POSTGRES_HOST":"test.rds.amazonaws.com",
            "POSTGRES_PORT":"5432",
            "POSTGRES_DB":"workshop",
            "POSTGRES_USERNAME":"postgres",
            "POSTGRES_PASSWORD":"postgres"
        }
        ```
        {{% notice tip %}}
Để lấy được giá trị của `POSTGRES_HOST`, sử dụng `arn:aws:secretsmanager:ap-southeast-1:1234567890:secret:workshop2:POSTGRES_HOST::` (giả sửa secret ARN là `arn:aws:secretsmanager:ap-southeast-1:1234567890:secret:workshop2`)   
Còn lấy toàn bộ giá trị của secret, sử dụng `arn:aws:secretsmanager:ap-southeast-1:1234567890:secret:workshop2`
        {{% /notice %}}

        ```shell
        # Nội dung của task-definition
        cat <<EOF | tee task-definition.json
        {
            "name": "$ecs_task_name",
            "image": "$ecs_task_uri",
            "portMappings": [
                {
                    "containerPort": 8080,
                    "hostPort": 8080
                }
            ],
            "secrets" : [
                {
                    "valueFrom" : "$secret_arn:POSTGRES_HOST::",
                    "name" : "POSTGRES_HOST"
                },
                {
                    "valueFrom" : "$secret_arn:POSTGRES_DB::",
                    "name" : "POSTGRES_DB"
                },
                {
                    "valueFrom" : "$secret_arn:POSTGRES_PASSWORD::",
                    "name" : "POSTGRES_PASSWORD"
                }
            ]
        }
        EOF
        ```

    2. Sử dụng file này để tạo Task Definition

        ```shell
        # Tạo task-definition
        ecs_task_definition=$(aws ecs register-task-definition \
            --family $ecs_task_name \
            --network-mode awsvpc \
            --requires-compatibilities EC2 \
            --cpu "512" \
            --memory "1024" \
            --execution-role-arn "$ecs_task_role_arn" \
            --tags "$tags2" \
            --container-definitions "`jq -c . task-definition.json`" )

        # Kiểm tra việc tạo ECS task definition
        aws ecs list-task-definitions

        ecs_task_arn=$(aws ecs describe-task-definition \
            --task-definition $ecs_task_name \
            --query "taskDefinition.taskDefinitionArn" \
            --output text)
        ```

## Thực hiện

1. Tạo IAM Role cho Task Definition
   
   1. Tạo IAM Role

        ![Create Task Role](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.1.png)
        
        Kiểm tra IAM Role vừa tạo bằng AWS Console

        ![Created IAM Role](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.4.png)

   2. Gắn các policy vào IAM Role này

        ![Attach policy for IAM Role](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.3.png)

        Kiểm tra policy của IAM Role bằng AWS Console

        ![Check Policy in IAM Role](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.5.png)

2. Tạo Task Definition

    1. Tạo tệp định nghĩa Task definition

        ![Create Task Definition config file](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.6.png)

    1. Sử dụng file này để tạo Task Definition

        ![Create Task Definition](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.7.png)

        Kiểm tra việc tạo ECS task definition bằng AWS Cli

        ![Get Task Definition ARN](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.8.png)

        Kiểm tra việc tạo ECS task definition bằng AWS Console

        ![Created Task Definition](/fcj-workshop2/images/6-ecs/6.3-task-definition/6.3.9.png)

## Tham khảo

[Specifying Sensitive Data Using Secrets Manager Secrets](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-tutorial.html)