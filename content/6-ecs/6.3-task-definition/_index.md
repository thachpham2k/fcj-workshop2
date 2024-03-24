---
title : "Creating ECS Task Definition"
menuTitle: "Task Definition"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre: "<b> 6.3. </b>"
description: "Create Task Definition. Task Definition is a blueprint for your application. It is a text file in JSON format that describes the parameters and one or more containers that form your application."
---

## Overview

{{% notice info %}}
A task definition is a blueprint for your application. It is a text file in JSON format that describes the parameters and one or more containers that form your application.
{{% /notice %}}

## Steps

1. Create an IAM Role for the Task Definition
   
   1. Create an IAM Role for the Task Definition with permissions used by `ecs-tasks.amazonaws.com`.

        ```shell
        # Get the ARN of AWS Secret Manager
        secret_arn=$(aws secretsmanager describe-secret --secret-id $secret_name --query 'ARN' --output text)
        # Create an IAM Role for the Task Definition
        ecs_task_role_name=$project-ecs-task-role
        ecs_task_policy_name=${project}_ecs_task_policy
        ecs_task_name=$project-task
        ecs_task_uri=$ecr_image_uri
        # Create an IAM Role
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

   2. Attach policies to this IAM Role

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

2. Create Task Definition

    1. Create a file defining the Task definition
        
        The content of the SecretsManager created beforehand is in JSON format as follows:

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
To obtain the value of `POSTGRES_HOST`, use `arn:aws:secretsmanager:ap-southeast-1:1234567890:secret:workshop2:POSTGRES_HOST::` (assuming the secret ARN is `arn:aws:secretsmanager:ap-southeast-1:1234567890:secret:workshop2`)   
To obtain the entire value of the secret, use `arn:aws:secretsmanager:ap-southeast-1:1234567890:secret:workshop2`
        {{% /notice %}}

        ```shell
        # Content of the task-definition
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

    2. Use this file to create the Task Definition

        ```shell
        # Create the task-definition
        ecs_task_definition=$(aws ecs register-task-definition \
            --family $ecs_task_name \
            --network-mode awsvpc \
            --requires-compatibilities EC2 \
            --cpu "512" \
            --memory "1024" \
            --execution-role-arn "$ecs_task_role_arn" \
            --tags "$tags2" \
            --container-definitions "`jq -c . task-definition.json`" )

        # Check the creation of ECS task definition
        aws ecs list-task-definitions

        ecs_task_arn=$(aws ecs describe-task-definition \
            --task-definition $ecs_task_name \
            --query "taskDefinition.taskDefinitionArn" \
            --output text)
        ```

## Execution

1. Create an IAM Role for the Task Definition
   
   1. Create an IAM Role

        ![Create Task Role](/images/6-ecs/6.3-task-definition/6.3.1.png)
        
        Verify the IAM Role created via the AWS Console

        ![Created IAM Role](/images/6-ecs/6.3-task-definition/6.3.4.png)

   2. Attach policies to this IAM Role

        ![Attach policy for IAM Role](/images/6-ecs/6.3-task-definition/6.3.3.png)

        Check the policy of IAM Role through the AWS Console

        ![Check Policy in IAM Role](/images/6-ecs/6.3-task-definition/6.3.5.png)

2. Create Task Definition

    1. Create a file defining the Task definition

        ![Create Task Definition config file](/images/6-ecs/6.3-task-definition/6.3.6.png)

    2. Use this file to create the Task Definition

        ![Create Task Definition](/images/6-ecs/6.3-task-definition/6.3.7.png)

        Verify the creation of ECS task definition via AWS CLI

        ![Get Task Definition ARN](/images/6-ecs/6.3-task-definition/6.3.8.png)

        Verify the creation of ECS task definition via AWS Console

        ![Created Task Definition](/images/6-ecs/6.3-task-definition/6.3.9.png)

## References

[Specifying Sensitive Data Using Secrets Manager Secrets](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-tutorial.html)