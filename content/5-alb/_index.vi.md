---
title : "Tạo Application Load Balancing (ALB)"
menuTitle: "ALB"
date :  "`r Sys.Date()`" 
weight : 5
chapter : false
pre: "<b> 5. </b>"
description: ""
---

## Tổng quan

{{% notice info %}}
Application Load Balancer hoạt động ở tầng ứng dụng, là tầng thứ bảy của mô hình Open Systems Interconnection (OSI).   
Sau khi ALB nhận yêu cầu, nó đánh giá các quy tắc trình nghe (listener rule) theo thứ tự ưu tiên để xác định quy tắc nào được áp dụng, sau đó chọn một mục tiêu từ Target Group để tiếp tục thực hiện.
{{% /notice %}}

![ALB Architecture](/fcj-workshop2/images/5-alb/introduce.png)

## Quy trình

1. Cấu hình biến

    ```shell
    alb_name=$project-alb
    alb_tgr_name=$project-tgr
    alb_vpc_id=$vpc_id
    alb_subnet1_id=$subnet_public_1
    alb_subnet2_id=$subnet_public_2
    ```

2. Tạo ALB

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

3. Tạo Target Group

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

4. Tạo Listener

    ```shell
    alb_listener_arn=$(aws elbv2 create-listener \
    --load-balancer-arn $alb_arn \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$alb_tgr_arn \
    --query 'Listeners[0].ListenerArn' \
    --output text)

    echo alb_listener_arn$alb_listener_arn
    ```

## Thực hiện

1. Cấu hình biến

2. Tạo ALB

    ![Create ALB](/fcj-workshop2/images/5-alb/5.1.png)

    Kiểm tra kết quả bằng AWS Console

    ![Created ALB](/fcj-workshop2/images/5-alb/5.2.png)

3. Tạo Target Group

    ![Create Target Group](/fcj-workshop2/images/5-alb/5.3.png)

    Kiểm tra kết quả bằng AWS Console

    ![Created Target Group](/fcj-workshop2/images/5-alb/5.4.png)

4. Tạo Listener

   ![Create Listener](/fcj-workshop2/images/5-alb/5.5.png)

    Kiểm tra kết quả bằng AWS Console

    ![Created Listener](/fcj-workshop2/images/5-alb/5.6.png)
