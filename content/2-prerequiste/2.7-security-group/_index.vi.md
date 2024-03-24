---
title: "Tạo Security Group"
menuTitle: "Security Group"
date: "`r Sys.Date()`"
weight: 7
chapter: false
pre: "<b> 2.7. </b>"
description: "Tạo các Security Group cho Instance, Relational Database Service và Application Load Balancer"
---

## Tổng quan

{{% notice info %}}
Security Group hoạt động như là một tưởng lửa ảo dành cho EC2 instance nhằm kiểm soát lưu lượng vào và ra.
{{% /notice %}}

Một bài viết khá hay của AWS Study Group liên quan đến Security Group mà bạn nên đọc để hiểu thêm về phần này [Bài 4: Các dịch vụ mạng trên AWS – Phần 2: AWS Security Groups với AWS Network Access Control List (NACL)](https://awsstudygroup.com/2023/04/27/bai-4-cac-dich-vu-mang-tren-aws-phan-2-aws-security-groups-voi-aws-network-access-control-list-nacl/)

Ở phần này, Chúng ta lần lượt sẽ tạo Security Group cho EC2 Instance, RDS và ALB.

## Quy trình

1. Tạo Security Group cho Instance

   Trong phần này, chúng ta tạo một Security Group cho các Instance. Mục đích của Security Group này là đảm bảo rằng các bên được phép truy cập vào instance chỉ qua các cổng được chọn.

   ```shell
   ecs_instance_sgr_name=$project-ecs-sgr
   # Tạo Security Group
   ecs_instance_sgr_id=$(aws ec2 create-security-group \
      --group-name $ecs_instance_sgr_name \
      --description "Security group for EC2 in ECS" \
      --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$ecs_instance_sgr_name'},'$tagspec` \
      --vpc-id $vpc_id | jq -r '.GroupId')

   aws ec2 authorize-security-group-ingress \
      --group-id $ecs_instance_sgr_id \
      --protocol tcp \
      --port 8080 \
      --cidr 0.0.0.0/0

   aws ec2 authorize-security-group-ingress \
      --gr  oup-id $ecs_instance_sgr_id \
      --protocol tcp \
      --port 22 \
      --cidr 0.0.0.0/0

   aws ec2 authorize-security-group-ingress \
      --group-id $ecs_instance_sgr_id \
      --protocol tcp \
      --port 443 \
      --cidr 0.0.0.0/0

   echo ecs_instance_sgr_id=$ecs_instance_sgr_id
   ```

   Trong mã trên:

   - `ecs_instance_sgr_name`: Đây là tên của Security Group cho các Instance, được tạo ra dựa trên biến `$project`.
   - `aws ec2 create-security-group`: Dòng này tạo một Security Group mới với tên và mô tả được chỉ định.
   - `aws ec2 authorize-security-group-ingress`: Các dòng này mở các cổng (port) cụ thể cho Security Group. Cụ thể là port `8080` (sử dụng cho ứng dụng), port `22` (sử dụng cho SSH), và port `443` (sử dụng cho các dịch vụ AWS : VPC endpoint,..).
   - `echo ecs_instance_sgr_id=$ecs_instance_sgr_id`: Dòng này in ra ID của Security Group mới được tạo.

2. Tạo Security Group cho RDS

   Trong phần này, chúng ta tạo một Security Group cho Relational Database Service (RDS). Mục đích của Security Group này là cho phép các Instance kết nối tới cổng sử dụng cho PostgreSQL.

   ```shell
   rds_sgr_name=$project-rds-sgr
   # Tạo Security Group
   rds_sgr_id=$(aws ec2 create-security-group \
      --group-name $rds_sgr_name  \
      --description "Security group for RDS" \
      --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$rds_sgr_name'},'$tagspec` \
      --vpc-id $vpc_id | jq -r '.GroupId')

   aws ec2 authorize-security-group-ingress \
      --group-id $rds_sgr_id \
      --protocol tcp \
      --port 5432 \
      --source-group $ecs_instance_sgr_id

   echo rds_sgr_id=$rds_sgr_id
   ```

   Trong mã trên:

   - `rds_sgr_name`: Đây là tên của Security Group cho RDS, dựa trên biến `$project`.
   - `aws ec2 create-security-group`: Dòng này tạo một Security Group mới cho RDS với các thông tin như tên và mô tả được chỉ định.
   - `aws ec2 authorize-security-group-ingress`: Dòng này cho phép các kết nối đến cổng `5432` (sử dụng cho PostgreSQL) từ Instance được chỉ định bởi `$ecs_instance_sgr_id`.
   - `echo rds_sgr_id=$rds_sgr_id`: Dòng này in ra ID của Security Group cho RDS.

3. Tạo Security Group for ALB

   Trong phần này, chúng ta tạo một Security Group cho Application Load Balancer (ALB). Mục đích của Security Group này là cho phép người dùng kết nối tới cổng sử dụng cho HTTP.

   ```shell
   alb_sgr_name=$project-alb-sgr
   # Tạo Security Group
   alb_sgr_id=$(aws ec2 create-security-group \
      --group-name $alb_sgr_name \
      --description "Security group for ALB" \
      --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$alb_sgr_name'},'$tagspec` \
      --vpc-id $vpc_id | jq -r '.GroupId')

   aws ec2 authorize-security-group-ingress \
      --group-id $alb_sgr_id \
      --protocol tcp \
      --port 22 \
      --cidr 0.0.0.0/0

   aws ec2 authorize-security-group-ingress \
      --group-id $alb_sgr_id \
      --protocol tcp \
      --port 80 \
      --cidr 0.0.0.0/0

   echo alb_sgr_id=$alb_sgr_id
   ```

   Trong mã trên:

   - `alb_sgr_name`: Đây là tên của Security Group cho ALB, dựa trên biến `$project`.
   - `aws ec2 create-security-group`: Dòng này tạo một Security Group mới cho ALB với các thông tin như tên và mô tả được chỉ định.
   - `aws ec2 authorize-security-group-ingress`: Dòng này cho phép các kết nối đến cổng `80` (sử dụng cho HTTP) từ mọi nơi (`0.0.0.0/0`)

## Thực hiện

1. Tạo Security Group cho Instance

   ![Create Instance Security Group](/images/2-prerequiste/2.7-security-group/2.7.1.png)

   Kiểm tra Security group vừa tạo bằng AWS Console

   ![Instance Security Group created success](/images/2-prerequiste/2.7-security-group/2.7.2.png)

2. Tạo Security Group cho RDS

   ![Create RDS Security Group](/images/2-prerequiste/2.7-security-group/2.7.3.png)

   Kiểm tra Security Group vừa tạo bằngAWS Console

   ![RDS Security Group created success](/images/2-prerequiste/2.7-security-group/2.7.4.png)

3. Tạo Security Group for ALB

   ![Create ALB Security Group](/images/2-prerequiste/2.7-security-group/2.7.5.png)

   Kiểm tra kết quả trên AWS Console

   ![ALB Security Group created success](/images/2-prerequiste/2.7-security-group/2.7.6.png)