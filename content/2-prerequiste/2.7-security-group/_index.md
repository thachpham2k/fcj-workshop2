---
title: "Create Security Group"
menuTitle: "Security Group"
date: "`r Sys.Date()`"
weight: 7
chapter: false
pre: "<b> 2.7. </b>"
description: "Create Security Groups for Instance, Relational Database Service, and Application Load Balancer"
---
## Overview

{{% notice info %}}
A security group acts as a virtual firewall for your EC2 instances to control incoming and outgoing traffic.
{{% /notice %}}

A helpful article by the AWS Study Group related to Security Groups that you should read to understand more about this topic is [Article 4: AWS Security Groups with AWS Network Access Control List (NACL)](https://awsstudygroup.com/2023/04/27/bai-4-cac-dich-vu-mang-tren-aws-phan-2-aws-security-groups-voi-aws-network-access-control-list-nacl/).

In this section, we will sequentially create Security Groups for EC2 Instances, RDS, and ALB.

## Steps

1. Create Security Group for Instance

   In this section, we create a Security Group for Instances. The purpose of this Security Group is to ensure that only selected ports are accessible to instances.

   ```shell
   ecs_instance_sgr_name=$project-ecs-sgr
   # Create Security Group
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
      --group-id $ecs_instance_sgr_id \
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

   In the above code:

   - `ecs_instance_sgr_name`: This is the name of the Security Group for Instances, created based on the `$project` variable.
   - `aws ec2 create-security-group`: This line creates a new Security Group with the specified name and description.
   - `aws ec2 authorize-security-group-ingress`: These lines open specific ports for the Security Group. Specifically, port `8080` (for applications), port `22` (for SSH), and port `443` (for AWS services: VPC endpoint, etc.).
   - `echo ecs_instance_sgr_id=$ecs_instance_sgr_id`: This line prints out the ID of the newly created Security Group.

2. Create Security Group for RDS

   In this section, we create a Security Group for Relational Database Service (RDS). The purpose of this Security Group is to allow Instances to connect to the port used for PostgreSQL.

   ```shell
   rds_sgr_name=$project-rds-sgr
   # Create Security Group
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

   In the above code:

   - `rds_sgr_name`: This is the name of the Security Group for RDS, based on the `$project` variable.
   - `aws ec2 create-security-group`: This line creates a new Security Group for RDS with the specified name and description.
   - `aws ec2 authorize-security-group-ingress`: This line allows connections to port `5432` (used for PostgreSQL) from the Instance specified by `$ecs_instance_sgr_id`.
   - `echo rds_sgr_id=$rds_sgr_id`: This line prints out the ID of the Security Group for RDS.

3. Create Security Group for ALB

   In this section, we create a Security Group for Application Load Balancer (ALB). The purpose of this Security Group is to allow users to connect to the port used for HTTP.

   ```shell
   alb_sgr_name=$project-alb-sgr
   # Create Security Group
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

   In the above code:

   - `alb_sgr_name`: This is the name of the Security Group for ALB, based on the `$project` variable.
   - `aws ec2 create-security-group`: This line creates a new Security Group for ALB with the specified name and description.
   - `aws ec2 authorize-security-group-ingress`: This line allows connections to port `80` (used for HTTP) from anywhere (`0.0.0.0/0`).

## Execution

1. Create Security Group for Instance

   ![Create Instance Security Group](/images/2-prerequiste/2.7-security-group/2.7.1.png)

   Check the created Security group using the AWS Console

   ![Instance Security Group created success](/images/2-prerequiste/2.7-security-group/2.7.2.png)

2. Create Security Group for RDS

   ![Create RDS Security Group](/images/2-prerequiste/2.7-security-group/2.7.3.png)

   Check the created Security Group using AWS Console

   ![RDS Security Group created success](/images/2-prerequiste/2.7-security-group/2.7.4.png)

3. Create Security Group for ALB

   ![Create ALB Security Group](/images/2-prerequiste/2.7-security-group/2.7.5.png)

   Check the result on the AWS Console

   ![ALB Security Group created success](/images/2-prerequiste/2.7-security-group/2.7.6.png)