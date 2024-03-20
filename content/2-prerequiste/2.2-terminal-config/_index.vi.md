---
title : "Cấu hình Terminal"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 2.2. </b> "
description: "Cài đặt công cụ và thiết lập biến môi trường"
---

## Công cụ JQ

{{% notice info %}}
**jq** là một công cụ mạnh mẽ và linh hoạt được sử dụng để xử lý dữ liệu JSON từ dòng lệnh. Nó cho phép bạn trích xuất, biến đổi, lọc và hiệu chỉnh dữ liệu JSON một cách dễ dàng.
{{% /notice %}}

Trong bài lab, các lệnh AWS Cli được sử dụng kết hợp với jq để lọc dữ liệu và biến đổi dữ liệu về dạng thích hợp.

JQ được tích hợp sẵn trong kho lưu trữ của nhiều nền tảng, giúp việc cài đặt trở nên dễ dàng. Đối với Ubuntu, sử dụng lệnh:

```shell
sudo apt install jq -y
```

Để tìm hiểu thêm về JQ và cách cài đặt, truy cập [trang chủ của jq](https://jqlang.github.io/jq/).

## Công cụ Tee

Ngoài `jq`, một công cụ khác được sử dụng trong bài lab là `tee`.

{{% notice info %}}
**Tee** là một tiện ích dòng lệnh được sử dụng để đọc từ đầu vào tiêu chuẩn (như đầu ra của một lệnh hoặc một tệp) và ghi dữ liệu vào một hoặc nhiều tệp và đầu ra tiêu chuẩn cùng một lúc.
{{% /notice %}}

Đơn giản thì `tee` giúp đưa đầu ra của lệnh trước **pipe** (`|`) vào trong một tệp. Bạn có thể thay thế `tee` bằng lệnh **redirection** (`>`) nếu thích. Ví dụ, `ls | tee list.txt` có thể được thay thế bằng `ls > list.txt`.

Tương tự như `jq`, `tee` là một công cụ phổ biến được sẵn có trong kho quản lý gói phần mềm, vì vậy bạn có thể cài đặt nó bằng một lệnh đơn giản bằng lệnh (trên Ubuntu): 

```shell
sudo apt install tee -y
```

## Biến Môi Trường

Phần này đơn giản chỉ để định nghĩa và lưu trữ các giá trị thường xuyên được sử dụng thông qua shell variable:

```shell
project=workshop2
# global architect
region=ap-southeast-1
az_01=${region}a
az_02=${region}b
az_03=${region}c
# tags
tags='[{"Key":"purpose", "Value":"workshop2"}, {"Key":"project", "Value":"fcj_workshop"}, {"Key":"author", "Value":"pthach_cli"}]'
tags2='[{"key":"purpose", "value":"workshop2"}, {"key":"project", "value":"fcj_workshop"}, {"key":"author", "value":"pthach_cli"}]'
tagspec='{Key=purpose,Value=workshop2},{Key=project,Value=fcj_workshop},{Key=author,Value=pthach_cli}]'
# Identity
aws_account_id=$(aws sts get-caller-identity --query 'Account' --output text)
# ecr
docker_image_name=container-image
ecr_image_uri=$aws_account_id.dkr.ecr.$region.amazonaws.com/${docker_image_name}:latest
```

Các biến này được chia thành 5 loại:
* Thông tin của bài lab: `project_name`
* Region & AZ
* Tags: bài lab sử dụng 3 kiểu khai báo tag khác nhau (Phần này hơi không đồng nhất giữa các dịch vụ khác nhau 🥲)
* aws_account_id: Đây là ID tài khoản AWS (root).
* ECR: Bao gồm tên container và ecr_image_uri (AWS sử dụng một cách chung để khai báo ecr uri, vì vậy ngay cả khi chưa tạo, bạn vẫn có thể biết 🤣)

Chạy

![Shell variable config](/fcj-workshop2/images/2-prerequiste/2.2-terminal-config/2.2.1-config.png)

## Mở rộng

Danh sách các biến được khai báo và sử dụng trong bài lab: (Dùng trong trường hợp sử dụng trang shell thứ hai hoặc muốn kiểm tra giá trị của biến)

```shell
# grep '^echo ' backup/command.sh | awk '!seen[$0]++'
echo "=========== aws cli"
echo "============ terminal config"
echo project=$project
echo region=$region
echo az_01=$az_01
echo az_02=$az_02
echo az_03=$az_03
echo tags=$tags
echo tags2=$tags2
echo tagspec=$tagspec
echo aws_account_id=$aws_account_id
echo docker_image_name=$docker_image_name
echo ecr_image_uri=$ecr_image_uri
echo "==="
echo "================2.3 iam"
echo ecs_instance_role_name=$ecs_instance_role_name
echo ecs_instance_profile_arn=$ecs_instance_profile_arn
echo "================ keypair"
echo ecs_instance_key_name=$ecs_instance_key_name
echo "==========ecr"
echo ecr_name=$ecr_name
echo "===========network"
echo vpc_name=$vpc_name
echo vpc_cidr=$vpc_cidr
echo vpc_id=$vpc_id
echo pubsubnet1_name=$pubsubnet1_name
echo pubsubnet2_name=$pubsubnet2_name
echo pubsubnet3_name=$pubsubnet3_name
echo pubsubnet1_cidr=$pubsubnet1_cidr
echo pubsubnet2_cidr=$pubsubnet2_cidr
echo pubsubnet3_cidr=$pubsubnet3_cidr
echo subnet_public_1=$subnet_public_1
echo subnet_public_2=$subnet_public_2
echo subnet_public_3=$subnet_public_3
echo prisubnet1_name=$prisubnet1_name
echo prisubnet2_name=$prisubnet2_name
echo prisubnet3_name=$prisubnet3_name
echo prisubnet1_cidr=$prisubnet1_cidr
echo prisubnet2_cidr=$prisubnet2_cidr
echo prisubnet3_cidr=$prisubnet3_cidr
echo subnet_private_1=$subnet_private_1
echo subnet_private_2=$subnet_private_2
echo subnet_private_3=$subnet_private_3
echo igw_name=$igw_name
echo gateway_id=$gateway_id
echo rtb_public_name=$rtb_public_name
echo rtb_public_id=$rtb_public_id
echo rtb_private_name=$rtb_private_name
echo rtb_private_id=$rtb_private_id
echo "============== security group"
echo ecs_instance_sgr_name=$ecs_instance_sgr_name
echo ecs_instance_sgr_id=$ecs_instance_sgr_id
echo rds_sgr_name=$rds_sgr_name
echo rds_sgr_id=$rds_sgr_id
echo alb_sgr_name=$alb_sgr_name
echo alb_sgr_id=$alb_sgr_id
echo "============== VPC Endpoint"
echo vpc_endpoint_s3=$vpc_endpoint_s3
echo vpc_endpoint_ecr_dkr=$vpc_endpoint_ecr_dkr
echo vpc_endpoint_ecr_api=$vpc_endpoint_ecr_api
echo vpc_endpoint_ecs=$vpc_endpoint_ecs
echo vpc_endpoint_ecs_agent=$vpc_endpoint_ecs_agent
echo vpc_endpoint_ecs_telemetry=$vpc_endpoint_ecs_telemetry
echo vpc_endpoint_ssm=$vpc_endpoint_ssm
echo vpc_endpoint_secretsmanager=$vpc_endpoint_secretsmanager
echo "============= RDS"
echo rds_subnet_group_name=$rds_subnet_group_name
echo rds_subnet_group_descript=$rds_subnet_group_descript
echo rds_subnet1_id=$rds_subnet1_id
echo rds_subnet2_id=$rds_subnet2_id
echo rds_name=$rds_name
echo rds_db_name=$rds_db_name
echo rds_db_username=$rds_db_username
echo rds_db_password=$rds_db_password
echo rds_address=$rds_address
echo "=========== secretsmanager" 
echo secret_name=$secret_name
echo secret_string=$secret_string
echo secret_arn=$secret_arn
echo "=========7. alb"
echo alb_name=$alb_name
echo alb_tgr_name=$alb_tgr_name
echo alb_vpc_id=$alb_vpc_id
echo alb_subnet1_id=$alb_subnet1_id
echo alb_subnet2_id=$alb_subnet2_id
echo alb_arn=$alb_arn
echo alb_tgr_arn=$alb_tgr_arn
echo alb_listener_arn$alb_listener_arn
echo "============ECS cluster"
echo ecs_cluster_name=$ecs_cluster_name
echo "========ECS Capacity"
echo ecs_instance_ami_id=$ecs_instance_ami_id
echo ecs_instance_type=$ecs_instance_type
echo ecs_instance_subnet_id=$ecs_instance_subnet_id
echo ECS_CLUSTER=$ecs_cluster_name >> /etc/ecs/ecs.config
echo ecs_launch_template_name=$ecs_launch_template_name
echo ecs_instance_name=$ecs_instance_name
echo ecs_autoscaling_group_name=$ecs_autoscaling_group_name
echo ecs_autoscaling_group_arn=$ecs_autoscaling_group_arn
echo ecs_capacity_provider=$ecs_capacity_provider
echo "========== task definition"
echo ecs_task_role_name=$ecs_task_role_name
echo ecs_task_policy_name=$ecs_task_policy_name
echo ecs_task_name=$ecs_task_name
echo ecs_task_uri=$ecs_task_uri
echo ecs_task_role_arn=$ecs_task_role_arn
echo ecs_task_arn=$ecs_task_arn
echo "=================== service"
echo ecs_service_name=$ecs_service_name
echo ecs_task_definition=$ecs_task_definition
```
