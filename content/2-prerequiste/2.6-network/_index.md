---
title: "Create Network"
menuTitle: "Network"
date: "`r Sys.Date()`"
weight: 6
chapter: false
pre: "<b> 2.6. </b>"
description: "Create a network system for the project including VPC, Subnet, Internet Gateway, Route Table"
---

## Overview

VPC, a core AWS networking service.

For further understanding of this section, you may want to read a comprehensive article by the AWS Study Group on networking in AWS: [Article 3: AWS Networking Services - Part 1: VPC Concepts](https://awsstudygroup.com/2023/04/27/bai-3-cac-dich-vu-mang-tren-aws-phan-1-khai-niem-vpc/).

In this section, we'll create a VPC with 6 subnets (3 private and 3 public distributed across 3 availability zones in the Singapore region), 1 Internet Gateway, and 1 Route Table.

## Steps

1. Create VPC

    ```shell
    # network
    vpc_cidr=10.1.0.0/16
    vpc_name=$project-vpc
    # Create VPC and Enable DNS hostname feature
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

2. Create Subnets
    
    Create 6 subnets, including 3 private and 3 public subnets distributed across 3 AZs (a, b, c) in the Singapore region (`ap-southeast-1`).

    1. Create Public Subnets
       
       * Public Subnet 1: 10.1.0.0/20
       * Public Subnet 2: 10.1.16.0/20
       * Public Subnet 3: 10.1.32.0/20
       
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
        # Create public subnets
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

    2. Create Private Subnets

       * Private Subnet 1: 10.1.128.0/20
       * Private Subnet 2: 10.1.144.0/20
       * Private Subnet 3: 10.1.160.0/20
        
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
        # Create private subnets
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

3. Create Internet Gateway

    Components in the network needing Internet access must pass through an Internet Gateway. The following commands help create an Internet Gateway and attach it to the previously created VPC:

    ```shell
    igw_name=$project-igw
    # Create Internet Gateway
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

    In the previous step, we created 3 Public Subnets, but currently, these Public Subnets cannot connect to the internet. To make these Public Subnets truly public, they need to be connected to the **Internet Gateway** through a **Route Table**.

    So, where is the Route Table for private subnets? At this point, private subnets will use the default Route Table provided by AWS. But what if we don't want to use the Default Route Table? In that case, we need to create a new Route Table.

    1. Create Public Route Table

        The following commands help the public subnets connect to the internet gateway. There are 3 main commands involved:
        * `aws ec2 create-route-table`: Create Route Table
        * `aws ec2 create-route`: Connect Route Table to Internet Gateway
        * `aws ec2 associate-route-table`: Connect Route Table to Subnets

        ```shell
        rtb_name=$project-rtb-public
        # Create Route table
        rtb_public_id=$(aws ec2 create-route-table \
            --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')

        aws ec2 create-route \
            --route-table-id $rtb_public_id \
            --destination-cidr-block 0.0.0.0/0 \
            --gateway-id $gateway_id

        # Associate each Public Subnet with the Route Table
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
        # Create Route table
        rtb_private_id=$(aws ec2 create-route-table \
            --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_name'},'$tagspec` \
            --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')

        # Associate each Private Subnet with the Route Table
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

## Execution


1. Create VPC

    ![Create VPC](/images/2-prerequiste/2.6-network/2.6.1.png)

    Check the created VPC using the AWS console

    ![Created VPC](/images/2-prerequiste/2.6-network/2.6.2.png)

2.  Create Subnets

    1. Create Public Subnet
        
        ![Create Public Subnet](/images/2-prerequiste/2.6-network/2.6.3.png)

        Check the created public subnets using the AWS Console

        ![Created Public Subnet](/images/2-prerequiste/2.6-network/2.6.4.png)

    2. Create Private Subnet

        ![Create private subnet](/images/2-prerequiste/2.6-network/2.6.5.png)

        Check the created private subnet using the AWS Console

        ![Created private subnet](/images/2-prerequiste/2.6-network/2.6.6.png)

3. Create Internet Gateway


    ![Create Internet Gateway](/images/2-prerequiste/2.6-network/2.6.7.png)

    Check the created Internet Gateway using the AWS Console

    ![Created Internet Gateway](/images/2-prerequiste/2.6-network/2.6.8.png)

4. Create Route Table and Routing

    1. Create Public Routable

        ![Create Route Table public](/images/2-prerequiste/2.6-network/2.6.9.png)

        Check the created public Route Table using the AWS Console

        ![Created Route Table Public](/images/2-prerequiste/2.6-network/2.6.10.png)

    2. Private Route Table

        ![Create Route Table Private](/images/2-prerequiste/2.6-network/2.6.11.png)
        
        Check the created private Route Table using the AWS Console
        
        ![Created Route Table Private](/images/2-prerequiste/2.6-network/2.6.12.png)
   