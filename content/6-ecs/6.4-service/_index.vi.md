---
title : "Tạo ECS Service"
menuTitle: "ECS Service"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre: "<b> 5.4. </b>"
description: "Tạo ECS Service, một dịch vụ chạy và quản lý một số lượng xác định các phiên bản của một task definition đồng thời trong một cluster Amazon ECS."
---

## Tổng quan

{{% notice info %}}
Amazon ECS (Elastic Container Service) Service là một dịch vụ chạy và quản lý một số lượng xác định các phiên bản của một task definition đồng thời trong một cluster Amazon ECS.
{{% /notice %}}

## Tạo ECS Service

Tạo ECS service dựa trên 1 task definition có sẵn bằng lệnh

```shell
ecs_service_name=$project-service
# Tạo Service
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
Chạy
![Create ECS Service](/fcj-workshop2/images/6-ecs/6.4-service/6.4.1.png)

![Update ECS Service](/fcj-workshop2/images/6-ecs/6.4-service/6.4.2.png)

Kiểm tra ECS Service vừa tạo bằng AWS Console

![Create ECS Service](/fcj-workshop2/images/6-ecs/6.4-service/6.4.3.png)

## Kiểm tra kết quả bài lab

1. Kiểm tra Target Group

    ```shell
    aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
    ```

    ![Target Group check Healthy](/fcj-workshop2/images/6-ecs/6.4-service/6.4.6.png)

2. Truy xuất ALB public DNS

    ```shell
    aws elbv2 describe-load-balancers \
        --load-balancer-arns $alb_arn \
        --query 'LoadBalancers[0].DNSName' \
        --output text
    ```
    
    ![Retrieve ALB DNS](/fcj-workshop2/images/6-ecs/6.4-service/6.4.5.png)

3. Kiểm tra ứng dụng bằng `api`

    ![Check Application](/fcj-workshop2/images/6-ecs/6.4-service/6.4.4.png)