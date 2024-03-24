---
title: "Tạo ECS Cluster"
menuTitle: "ECS Cluster"
date: "`r Sys.Date()`"
weight: 1
chapter: false
pre: "<b> 6.1. </b>"
description: "Cách tạo và quản lý ECS cluster là một nhóm về mặt logic của các ECS tasks hay services, cùng với các tài nguyên cơ sở hạ tầng cần thiết như các instance EC2, AWS Fargate hoặc các máy ảo trên nền tảng riêng"
---

## Tổng quan

{{% notice info %}}
ECS cluster là một nhóm về mặt logic của các ECS tasks hay services.
{{% /notice %}}

Ngoài các tasks and services, a cluster bao gồm các tài nguyên sau:
- Hạ tầng:
  - Amazon EC2 instances trên AWS
  - Serverless (AWS Fargate (Fargate)) trên AWS
  - On-premises virtual machines (VM) hoặc servers
- Mạng (VPC and subnet).
- A namespace: được sử dụng cho giao tiếp từ dịch vụ này sang dịch vụ khác với Service Connect.
- A monitoring option: **CloudWatch Container Insights**  tự động thu thập, tổng hợp và tóm tắt các số liệu và nhật ký của Amazon ECS.

## Quy trình

Sử dụng lệnh sau để tạo một Cluster ECS.

```shell
ecs_cluster_name=$project-cluster
# Create ECS Cluster
aws ecs create-cluster \
    --cluster-name $ecs_cluster_name \
    --region $region \
    --tags "$tags2"

# Check ECS Cluster created correctly
aws ecs list-clusters
```

## Thực hiện

![Create ECS Cluster](/images/6-ecs/6.1-cluster/6.1.1.png)

Kiểm tra kết quả trên AWS Console

![Created ECS Cluster](/images/6-ecs/6.1-cluster/6.1.2.png)
