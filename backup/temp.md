---
title : "Create ECS Service"
menuTitle: "ECS Service"
date :  "`r Sys.Date()`" 
weight : 4
chapter : false
pre: "<b> 5.4. </b>"
description: "Guide to create and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster."
---

## Overview

{{% notice info %}}
You can use an Amazon ECS service to run and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster.
{{% /notice %}}

## Creating ECS Service



```shell
ecs_service_name=$project-service
# Create Service
aws ecs create-service \
   --cluster $ecs_cluster_name \
   --service-name $ecs_service_name \
   --task-definition $ecs_task_arn \
   --desired-count 1 \
   --network-configuration "awsvpcConfiguration={subnets=[$subnet_public_1],securityGroups=[$ecs_instance_sgr_id]}"
```



![Create ECS service](6.4.2-service.png)



![Create ECS service](6.4.3-service.png)