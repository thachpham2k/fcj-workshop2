---
title : "Dọn dẹp tài nguyên"
date :  "`r Sys.Date()`" 
weight : 7
chapter : false
pre: "<b> 7. </b>"
---

## Xóa ALB và các thành phần liên quan

```shell
aws elbv2 delete-listener --listener-arn $alb_listener_arn

aws elbv2 delete-target-group --target-group-arn $alb_tgr_arn

aws elbv2 delete-load-balancer --load-balancer-arn $alb_arn
```

## Xóa ECS Service

```shell
aws ecs delete-service --cluster $ecs_cluster_name \
    --service $ecs_service_name --force
```

## Xóa ECS Task Definition

```shell
task_definition_arns=$(aws ecs list-task-definitions \
    --status ACTIVE \
    --query 'taskDefinitionArns[]' --output text)

for arn in $task_definition_arns; do
    aws ecs deregister-task-definition --task-definition $arn
done

task_definition_inactive_arns=$(aws ecs list-task-definitions \
    --status INACTIVE \
    --query 'taskDefinitionArns[]' --output text)

aws ecs delete-task-definitions \
    --task-definitions $task_definition_inactive_arns
```

## Xóa Task Role

```shell
aws iam delete-role-policy \
    --role-name $ecs_task_role_name \
    --policy-name $ecs_task_policy_name

aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
    --role-name $ecs_task_role_name

aws iam delete-role --role-name $ecs_task_role_name
```

## Xóa ECS instance và các thành phần liên quan

```shell
instance_ids=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ecs_autoscaling_group_name \
    --query "AutoScalingGroups[].Instances[].InstanceId" \
    --output text)

aws autoscaling delete-auto-scaling-group \
    --auto-scaling-group-name $ecs_autoscaling_group_name \
    --force-delete

aws ec2 terminate-instances --instance-ids $instance_ids
aws ec2 wait instance-terminated --instance-ids $instance_ids

aws ec2 delete-launch-template \
    --launch-template-name $ecs_launch_template_name
```

## Xóa ECS Cluster

```shell
aws ecs delete-cluster --cluster $ecs_cluster_name
```

## Xóa ECS Capacity Provider

```shell
# aws ecs put-cluster-capacity-providers \
#     --cluster $ecs_cluster_name \
#     --capacity-providers $ecs_capacity_provider \
#     --default-capacity-provider-strategy capacityProvider=$ecs_capacity_provider,weight=0,base=0

aws ecs delete-capacity-provider --capacity-provider $ecs_capacity_provider
```

## Xóa Secrets Manager

```shell
aws secretsmanager delete-secret \
    --secret-id $secret_name \
    --force-delete-without-recovery
```

## Xóa RDS

```shell
aws rds delete-db-instance \
    --db-instance-identifier $rds_name \
    --skip-final-snapshot

aws rds wait db-instance-deleted --db-instance-identifier $rds_name

aws rds delete-db-subnet-group --db-subnet-group-name $rds_subnet_group_name
```

## Xóa Security Group

```shell
aws ec2 delete-security-group --group-id $alb_sgr_id

aws ec2 delete-security-group --group-id $rds_sgr_id

aws ec2 delete-security-group --group-id $ecs_instance_sgr_id
```

## Xóa Network

```shell
aws ec2 delete-subnet --subnet-id $subnet_public_1
aws ec2 delete-subnet --subnet-id $subnet_public_2
aws ec2 delete-subnet --subnet-id $subnet_public_3

aws ec2 delete-subnet --subnet-id $subnet_private_1
aws ec2 delete-subnet --subnet-id $subnet_private_2
aws ec2 delete-subnet --subnet-id $subnet_private_3

aws ec2 delete-route-table --route-table-id $rtb_public_id
aws ec2 delete-route-table --route-table-id $rtb_private_id

aws ec2 detach-internet-gateway \
    --internet-gateway-id $gateway_id \
    --vpc-id $vpc_id
aws ec2 delete-internet-gateway --internet-gateway-id $gateway_id

aws ec2 delete-vpc --vpc-id $vpc_id
```

## Xóa ECR

```shell
aws ecr batch-delete-image \
    --repository-name $ecr_name \
    --image-ids imageTag=latest \
    --region $region

aws ecr delete-repository \
    --repository-name $ecr_name \
    --force \
    --region $region

docker rmi $ecr_image_uri

docker rmi $ecr_name

# docker rmi $(docker image ls -aq)
```

## Xóa Keypair

```shell
aws ec2 delete-key-pair --key-name $ecs_instance_key_name

rm -f $ecs_instance_key_name.pem
```

## Xóa IAM Role

```
aws iam remove-role-from-instance-profile \
    --instance-profile-name $ecs_instance_role_name \
    --role-name $ecs_instance_role_name

aws iam delete-instance-profile \
    --instance-profile-name $ecs_instance_role_name

aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
    --role-name $ecs_instance_role_name

aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
    --role-name $ecs_instance_role_name

aws iam delete-role --role-name $ecs_instance_role_name
```