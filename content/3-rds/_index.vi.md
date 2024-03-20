---
title: "Tạo Relational Database Service"
menuTitle: "RDS"
date: "`r Sys.Date()`"
weight: 3
chapter: false
pre: "<b> 3. </b>"
description: "Tạo RDS subnet group and triển khai RDS"
---

## Tổng quan

{{% notice info %}}
Dịch vụ cơ sở dữ liệu quan hệ của Amazon (Amazon RDS) là một tập hợp các dịch vụ được quản lý giúp bạn dễ dàng thiết lập, vận hành và điều chỉnh quy mô cơ sở dữ liệu trên đám mây. 
{{% /notice %}}

Trong phần này, chúng ta sẽ thiết lập Dịch vụ Cơ sở dữ liệu Quan hệ (RDS) trên AWS

## Quy trình

1. Tạo RDS Subnet Group

    Trong phần này, chúng ta tạo một RDS Subnet Group

    ```shell
    rds_subnet_group_name=$project-subnet-group
    rds_subnet_group_descript="Subnet Group for Postgres RDS"
    rds_subnet1_id=$subnet_private_1
    rds_subnet2_id=$subnet_private_2 
    # Create Subnet group
    aws rds create-db-subnet-group \
        --db-subnet-group-name $rds_subnet_group_name \
        --db-subnet-group-description "$rds_subnet_group_descript" \
        --subnet-ids $rds_subnet1_id $rds_subnet2_id \
        --tags "$tags"
    ```

    Trong mã trên:

    - `rds_subnet_group_name`: Đây là tên của Nhóm Subnet RDS, dựa trên biến `$project`.
    - `aws rds create-db-subnet-group`: Dòng này tạo một Nhóm Subnet RDS với tên và mô tả được chỉ định, và liên kết nó với các subnet riêng tư.

    {{% notice warning %}}
    RDS subnet group cần tối thiểu 2 subnet
    {{% /notice %}}

2. Deploy RDS

    Trong phần này, chúng ta triển khai Dịch vụ Cơ sở dữ liệu Quan hệ (RDS) bằng cách sử dụng Nhóm Subnet RDS đã tạo trước đó.

    ```shell
    rds_name=$project-rds
    rds_db_name="workshop"
    rds_db_username="postgres"
    rds_db_password="postgres"
    # Create RDS
    aws rds create-db-instance \
        --db-instance-identifier $rds_name \
        --engine postgres \
        --db-name $rds_db_name \
        --db-instance-class db.t3.micro \
        --allocated-storage 20 \
        --master-username $rds_db_username \
        --master-user-password $rds_db_password \
        --storage-type gp2 \
        --no-enable-performance-insights \
        --availability-zone $az_01 \
        --db-subnet-group-name $rds_subnet_group_name \
        --vpc-security-group-ids $rds_sgr_id \
        --backup-retention-period 0 \
        --tags "$tags"

    aws rds wait db-instance-available \
        --db-instance-identifier $rds_name

    # Get RDS information
    rds_address=$(aws rds describe-db-instances \
        --db-instance-identifier $rds_name \
        --query 'DBInstances[0].Endpoint.Address' \
        --output text)
    echo rds_address=$rds_address
    ```

    Trong đoạn code trên:

    - `rds_instance_name`: Đây là tên của phiên bản RDS, dựa trên biến `$project`.
    - `aws rds create-db-instance`: Dòng này triển khai một phiên bản RDS với cấu hình cụ thể, bao gồm lớp phiên bản, loại engine, kích thước lưu trữ, nhóm subnet, nhóm bảo mật, tên người dùng chính, và mật khẩu.
    - `aws rds describe-db-instances` để lấy thông tin chi tiết về một phiên bản RDS dựa trên định danh của nó (`db-instance-identifier`) và sử dụng `--query 'DBInstances[0].Endpoint.Address'`: để tìm ra địa chỉ của DB instance từ json mà lệnh trả về

## Thực hiện


1. Tạo RDS Subnet Group

    ![Create RDS Subnet Group](/fcj-workshop2/images/3-rds/3.1.png)

    Kiểm tra trên AWS console

    ![RDS Subnet Group Created success](/fcj-workshop2/images/3-rds/3.2.png)

2. Deploy RDS

    ![Deploy RDS Instance](/fcj-workshop2/images/3-rds/3.3.png)

    Truy vấn địa chỉ của RDS Instance

    ![Get RDS Instance Address](/fcj-workshop2/images/3-rds/3.4.png)

    Kiểm tra kết quả trên AWS Console

    ![RDS Instance deployed successfully](/fcj-workshop2/images/3-rds/3.5.png)

    ![RDS Instance deployed successfully](/fcj-workshop2/images/3-rds/3.6.png)
