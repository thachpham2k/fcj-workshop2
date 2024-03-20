---
title: "Tạo mạng"
menuTitle: "Network"
date :  "`r Sys.Date()`" 
weight : 6
chapter : false
pre : " <b> 2.6. </b> "
description: "Tạo hệ thống mạng cho project bao gồm: VPC, Subnet, Internet Gateway, Route Table"
---

## Tổng quan

VPC thì chắc không cần phải giới thiệu nhiều rồi, đây là dịch vụ mạng của AWS.

Một bài viết khá hay của AWS Study Group về network trên AWS mà bạn nên đọc để hiểu thêm về phần này [Bài 3: Các dịch vụ mạng trên AWS – Phần 1: Khái niệm VPCS](https://awsstudygroup.com/2023/04/27/bai-3-cac-dich-vu-mang-tren-aws-phan-1-khai-niem-vpc/)

Trong phần này chúng ta sẽ tạo 1 VPC với 6 subnet (3 private và 3 public nằm ở 3 available zone của region singapore), 1 Internet Gateway và 1 Route Table.

## Quy trình

1. Tạo VPC

    ```shell
    # network
    vpc_cidr=10.1.0.0/16
    vpc_name=$project-vpc
    # Tạo VPC và Bật tính năng dns-hostname trong VPC
    vpc_id=$(aws ec2 create-vpc \
        --cidr-block $vpc_cidr \
        --region $region \
        --tag-specifications `echo 'ResourceType=vpc,Tags=[{Key=Name,Value='$vpc_name'},'$tagspec` \
        --output text \
        --query 'Vpc.VpcId')

    aws ec2 modify-vpc-attribute \
        --vpc-id $vpc_id \
        --enable-dns-hostnames '{"Value": true}'

    echo vpc_id=$vpc_id
    ```

2.  Tạo Subnet
    
    Tạo 6 subnet, bao gồm 3 subnet riêng tư và 3 subnet công cộng chia ra cho 3 AZ a, b, c của khu vực Singapore (`ap-southeast-1`).

    1. Tạo Public Subnet
       
       * public subnet 1=10.1.0.0/20
       * public subnet 2=10.1.16.0/20
       * public subnet 3=10.1.32.0/20
       
        ```shell
        

        for (( i=1; i<=3; i++ ))
        do
            eval pubsubnet${i}_cidr=\"10.1.$((($i-1)*16)).0/20\"
        done
        echo pubsubnet1_cidr=$pubsubnet1_cidr
        echo pubsubnet2_cidr=$pubsubnet2_cidr
        echo pubsubnet3_cidr=$pubsubnet3_cidr

        pubsubnet1_name=$project-pubsubnet-$az_01
        pubsubnet2_name=$project-pubsubnet-$az_02
        pubsubnet3_name=$project-pubsubnet-$az_03
        # Tạo public subnet
        subnet_public_1=$(aws ec2 create-subnet \
            --availability-zone $az_01 \
            --cidr-block $pubsubnet1_cidr \
            --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet1_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

        subnet_public_2=$(aws ec2 create-subnet \
            --availability-zone $az_02 \
            --cidr-block $pubsubnet2_cidr \
            --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet2_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

        subnet_public_3=$(aws ec2 create-subnet \
            --availability-zone $az_03 \
            --cidr-block $pubsubnet3_cidr \
            --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet3_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

        echo subnet_public_1=$subnet_public_1
        echo subnet_public_2=$subnet_public_2
        echo subnet_public_3=$subnet_public_3
        ```

    2. Tạo Private Subnet

       * private subnet 1=10.1.128.0/20
       * private subnet 2=10.1.144.0/20
       * private subnet 3=10.1.160.0/20
        
        ```shell
        for (( i=1; i<=3; i++ ))
        do
            eval prisubnet${i}_cidr=\"10.1.$((($i+3)*16)).0/20\"
        done
        echo prisubnet1_cidr=$prisubnet1_cidr
        echo prisubnet2_cidr=$prisubnet2_cidr
        echo prisubnet3_cidr=$prisubnet3_cidr
        prisubnet1_name=$project-prisubnet-$az_01
        prisubnet2_name=$project-prisubnet-$az_02
        prisubnet3_name=$project-prisubnet-$az_03
        # Tạo private subnet
        subnet_private_1=$(aws ec2 create-subnet \
            --availability-zone $az_01 \
            --cidr-block $prisubnet1_cidr \
            --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet1_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

        subnet_private_2=$(aws ec2 create-subnet \
            --availability-zone $az_02 \
            --cidr-block $prisubnet2_cidr \
            --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet2_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

        subnet_private_3=$(aws ec2 create-subnet \
            --availability-zone $az_03 \
            --cidr-block $prisubnet3_cidr \
            --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet3_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

        echo subnet_private_1=$subnet_private_1
        echo subnet_private_2=$subnet_private_2
        echo subnet_private_3=$subnet_private_3
        ```

3. Tạo Internet Gateway

    Các thành phần trong mạng cần truy cập Internet phải đi qua Internet Gateway. Các lệnh sau giúp tạo một Internet Gateway và gắn nó vào VPC đã được tạo trước đó:

    ```shell
    igw_name=$project-igw
    # Tạo Internet Gateway
    gateway_id=$(aws ec2 create-internet-gateway \
        --region $region \
        --tag-specifications `echo 'ResourceType=internet-gateway,Tags=[{Key=Name,Value='$igw_name'},'$tagspec` \
        --output text \
        --query 'InternetGateway.InternetGatewayId')

    aws ec2 attach-internet-gateway \
        --vpc-id $vpc_id \
        --internet-gateway-id $gateway_id

    echo gateway_id=$gateway_id
    ```

4. Create Route Table and Routing

    Ở bước trước, chúng ta đã tạo 3 Public Subnet, nhưng hiện tại, các Public Subnet này không thể kết nối đến internet. Để các Public Subnet này trở thành Public Subnet thực sự thì chúng cần phải kết nối chúng với **Internet Gateway** thông qua **Route Table**.

    Vậy thì Route Table của private subnet đâu? private table lúc này sẽ sử dụng default Route Table được tạo với AWS. Thế nếu không sử dụng Default Route Table thì sao? thì phải tạo 1 Route Table

    1. Create Public Routable

        Các lệnh sau đây giúp các public subnet kết nối đến internet gateway. Có 3 lệnh chính là
        * `aws ec2 create-route-table`: tạo Route Table
        * `aws ec2 create-role`: kết nối Route Table với Internet Gateway
        * `aws ec2 associate-route-table`: kết nối Route Table với Subnet

        ```shell
        rtb_name=$project-rtb-public
        # Tạo Route table
        rtb_public_id=$(aws ec2 create-route-table \
            --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')

        aws ec2 create-route \
            --route-table-id $rtb_public_id \
            --destination-cidr-block 0.0.0.0/0 \
            --gateway-id $gateway_id

        # Gán mỗi Public Subnet với the Route Table
        aws ec2 associate-route-table \
            --subnet-id $subnet_public_1 \
            --route-table-id $rtb_public_id

        aws ec2 associate-route-table \
            --subnet-id $subnet_public_2 \
            --route-table-id $rtb_public_id

        aws ec2 associate-route-table \
            --subnet-id $subnet_public_3 \
            --route-table-id $rtb_public_id

        echo rtb_public_id=$rtb_public_id
        ``` 

    2. Private Route Table

        ```shell
        rtb_name=$project-rtb-private
        echo rtb_name=$rtb_name
        # Tạo Route table
        rtb_private_id=$(aws ec2 create-route-table \
            --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')

        # Gán mỗi Public Subnet với the Route Table
        aws ec2 associate-route-table \
            --subnet-id $subnet_private_1 \
            --route-table-id $rtb_private_id

        aws ec2 associate-route-table \
            --subnet-id $subnet_private_2 \
            --route-table-id $rtb_private_id

        aws ec2 associate-route-table \
            --subnet-id $subnet_private_3 \
            --route-table-id $rtb_private_id

        echo rtb_private_id=$rtb_private_id
        ``` 

## Thực hiện


1. Tạo VPC

    ![Create VPC](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.1.png)

    Kiểm tra VPC vừa tạo bằng AWS console

    ![Created VPC](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.2.png)

2.  Tạo Subnet

    1. Tạo Public Subnet
        
        ![Create Public Subnet](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.3.png)

        Kiểm tra các public subnet vừa tạo bằng AWS Console

        ![Created Public Subnet](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.4.png)

    2. Tạo Private Subnet

        ![Create private subnet](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.5.png)

        Kiểm tra private subnet vừa được tạo bằng AWS Console

        ![Created private subnet](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.6.png)

3. Tạo Internet Gateway


    ![Create Internet Gateway](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.7.png)

    Kiểm tra internet gateway vừa được tạo bằng AWS Console

    ![Created Internet Gateway](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.8.png)

4. Create Route Table and Routing

    1. Create Public Routable

        ![Create Route Table public](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.9.png)

        Kiểm tra Route Table public vừa tạo bằng AWS Console

        ![Created Route Table Public](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.10.png)

    2. Private Route Table

        ![Create Route Table Private](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.11.png)
        
        Kiểm tra Route Table private vừa tạo bằng AWS Console
        
        ![Created Route Table Private](/fcj-workshop2/images/2-prerequiste/2.6-network/2.6.12.png)
