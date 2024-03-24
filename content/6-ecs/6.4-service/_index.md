---
title : "Tạo ECS Service"
menuTitle: "ECS Service"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre: "<b> 6.4. </b>"
description: ""
---

## Tổng quan

{{% notice info %}}
Amazon ECS (Elastic Container Service) Service is a service that run and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster.
{{% /notice %}}

## Creating ECS Service

Create an ECS service based on an existing task definition using the following commands:

```shell
ecs_service_name=$project-service
# Create Service
aws ecs create-service \
   --cluster $ecs_cluster_name \
   --service-name $ecs_service_name \
   --task-definition $ecs_task_arn \
   --desired-count 1 \
   --network-configuration "awsvpcConfiguration={subnets=[$ecs_instance_subnet_id],securityGroups=[$ecs_instance_sgr_id]}" 

aws ecs update-service --cluster $ecs_cluster_name \
    --service $ecs_service_name \
    --desired-count 1 \
    --load-balancers targetGroupArn=$alb_tgr_arn,containerName=`echo $ecs_task_definition | jq -r '.taskDefinition.containerDefinitions[0].name'`,containerPort=8080
```

Execution:
![Create ECS Service](/images/6-ecs/6.4-service/6.4.1.png)

![Update ECS Service](/images/6-ecs/6.4-service/6.4.2.png)

Verify the ECS Service created using the AWS Console:

![Create ECS Service](/images/6-ecs/6.4-service/6.4.3.png)

## Checking Lab Results

1. Check the Target Group

    ```shell
    aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
    ```

    ![Target Group check Healthy](/images/6-ecs/6.4-service/6.4.6.png)

2. Access the ALB public DNS

    ```shell
    aws elbv2 describe-load-balancers \
        --load-balancer-arns $alb_arn \
        --query 'LoadBalancers[0].DNSName' \
        --output text
    ```
    
    ![Retrieve ALB DNS](/images/6-ecs/6.4-service/6.4.5.png)

3. Check the application using the `api` endpoint

    ![Check Application](/images/6-ecs/6.4-service/6.4.4.png)