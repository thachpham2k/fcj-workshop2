---
title : "Tạo Application Load Balancing (ALB)"
menuTitle: "ALB"
date :  "`r Sys.Date()`" 
weight: 5
chapter: false
pre: "<b> 5. </b>"
description: "Create an Application Load Balancer (ALB) to distribute incoming traffic across multiple targets."
---

## Overview

{{% notice info %}}
The Application Load Balancer operates at the application layer (Layer 7) of the Open Systems Interconnection (OSI) model. 
After receiving a request, the ALB evaluates listener rules in priority order to determine which rule to apply, then selects a target from a Target Group to continue processing.
{{% /notice %}}

![ALB Architecture](/fcj-workshop2/images/5-alb/introduce.png)

## Procedure

1. Configure Variables

    ```shell
    alb_name=$project-alb
    alb_tgr_name=$project-tgr
    alb_vpc_id=$vpc_id
    alb_subnet1_id=$subnet_public_1
    alb_subnet2_id=$subnet_public_2
    ```

2. Create ALB

    ```shell
    # Create ALB
    alb_arn=$(aws elbv2 create-load-balancer \
        --name $alb_name  \
        --subnets $alb_subnet1_id $alb_subnet2_id \
        --security-groups $alb_sgr_id \
        --tags "$tags" \
        --query 'LoadBalancers[0].LoadBalancerArn' \
        --output text)

    echo alb_arn=$alb_arn
    ```

3. Create Target Group

    ```shell
    alb_tgr_arn=$(aws elbv2 create-target-group \
        --name $alb_tgr_name \
        --protocol HTTP \
        --target-type ip \
        --health-check-path "/api/product" \
        --port 8080 \
        --vpc-id $alb_vpc_id \
        --tags "$tags" \
        --query 'TargetGroups[0].TargetGroupArn' \
        --output text)
    
    echo alb_tgr_arn=$alb_tgr_arn
    ```

4. Create Listener

    ```shell
    alb_listener_arn=$(aws elbv2 create-listener \
    --load-balancer-arn $alb_arn \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$alb_tgr_arn \
    --query 'Listeners[0].ListenerArn' \
    --output text)

    echo alb_listener_arn=$alb_listener_arn
    ```

## Execution

1. Configure Variables

2. Create ALB

    ![Create ALB](/fcj-workshop2/images/5-alb/5.1.png)

    Check the result on the AWS Console

    ![Created ALB](/fcj-workshop2/images/5-alb/5.2.png)

3. Create Target Group

    ![Create Target Group](/fcj-workshop2/images/5-alb/5.3.png)

    Check the result on the AWS Console

    ![Created Target Group](/fcj-workshop2/images/5-alb/5.4.png)

4. Create Listener

   ![Create Listener](/fcj-workshop2/images/5-alb/5.5.png)

    Check the result on the AWS Console

    ![Created Listener](/fcj-workshop2/images/5-alb/5.6.png)