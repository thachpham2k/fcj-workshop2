---
title : "Introduction"
date :  "`r Sys.Date()`" 
weight: 1
chapter: false
pre: "<b> 1. </b>"
---

## Overview

In this lab, we will use Amazon Web Services (AWS) to construct a system capable of deploying a web application in a containerized environment. This will involve using the Application Load Balancer (ALB) for load distribution, Amazon ECS for container management, and Amazon RDS to deploy a PostgreSQL database.

1. **Amazon ECS (Elastic Container Service)**:
   - Amazon ECS is a managed service for containerized applications on AWS.
   - ECS allows us to deploy, manage, and scale Docker containers on a cluster of EC2 instances.
   - In this lab, ECS is used to manage containers hosting our web application.

2. **Amazon RDS (Relational Database Service)**:
   - Amazon RDS is an easy-to-use managed relational database service on AWS.
   - RDS offers deployment and operation of popular relational databases like PostgreSQL, MySQL, SQL Server, and Oracle.
   - In this lab, we utilize RDS to deploy the PostgreSQL database.

3. **Amazon ALB (Application Load Balancer)**:
   - Amazon ALB is a service providing dynamic load distribution for applications running on AWS.
   - ALB enables load distribution based on the content of HTTP/HTTPS requests, improving the performance and reliability of applications.
   - In this lab, ALB is used to route requests to ECS containers hosting our web application.

4. **AWS Secrets Manager**:
   - AWS Secrets Manager is a security management service allowing the storage and management of secrets such as login information, API keys, and other sensitive data.
   - In this lab, AWS Secrets Manager is used to securely store connection information for the PostgreSQL database.

## Content

{{% children  %}}