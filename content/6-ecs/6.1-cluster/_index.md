---
title: "Creating ECS Cluster"
menuTitle: "ECS Cluster"
date: "`r Sys.Date()`"
weight: 1
chapter: false
pre: "<b> 6.1. </b>"
description: "Create and manage an Amazon ECS cluster, which is a logical grouping of tasks or services, along with the necessary infrastructure resources like EC2 instances, AWS Fargate, or on-premises virtual machines."
---

## Overview

{{% notice info %}}
An Amazon ECS cluster is a logical grouping of tasks or services.
{{% /notice %}}

In addition to tasks and services, a cluster consists of the following resources:
- The infrastructure capacity which can be a combination of the following:
  - Amazon EC2 instances in the AWS cloud
  - Serverless (AWS Fargate) in the AWS cloud
  - On-premises virtual machines (VM) or servers
- The network (VPC and subnet) where your tasks and services run
    When you use Amazon EC2 instances for the capacity, the subnet can be in Availability Zones, Local Zones, Wavelength Zones, or AWS Outposts.
- An optional namespace
  - The namespace is used for service-to-service communication with Service Connect.
- A monitoring option
  - CloudWatch Container Insights comes at an additional cost and is a fully managed service. It automatically collects, aggregates, and summarizes Amazon ECS metrics and logs.

## Steps

Use the following command to create an ECS Cluster.

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

## Execution

![Create ECS Cluster](/images/6-ecs/6.1-cluster/6.1.1.png)

Check the result on the AWS Console

![Created ECS Cluster](/images/6-ecs/6.1-cluster/6.1.2.png)