---
title : "Giới thiệu"
date :  "`r Sys.Date()`" 
weight : 1 
chapter : false
pre : " <b> 1. </b> "
---

## Tổng quan

Trong bài lab này, chúng ta sử dụng một số dịch vụ của Amazon Web Services (AWS) để xây dựng một hệ thống có khả năng triển khai ứng dụng web trên môi trường container, với việc sử dụng Application Load Balancer (ALB) để phân phối tải, Amazon ECS để quản lý container, và Amazon RDS để triển khai cơ sở dữ liệu PostgreSQL. 

1. **Amazon ECS (Elastic Container Service)**:
   - Amazon ECS là một dịch vụ quản lý containerized applications trên AWS.
   - ECS cho phép chúng ta triển khai, quản lý và mở rộng các container Docker trên một nhóm các máy chủ EC2.
   - Trong bài lab, ECS được sử dụng để quản lý container chứa ứng dụng web của chúng ta.

2. **Amazon RDS (Relational Database Service)**:
   - Amazon RDS là một dịch vụ cơ sở dữ liệu quan hệ quản lý dễ dàng trên AWS.
   - RDS cung cấp khả năng triển khai và vận hành cơ sở dữ liệu quan hệ phổ biến như PostgreSQL, MySQL, SQL Server và Oracle.
   - Trong bài lab, chúng ta sử dụng RDS để triển khai cơ sở dữ liệu PostgreSQL.

3. **Amazon ALB (Application Load Balancer)**:
   - Amazon ALB là một dịch vụ cung cấp phân phối tải động cho các ứng dụng chạy trên AWS.
   - ALB cho phép phân phối tải dựa trên nội dung của yêu cầu HTTP/HTTPS, giúp cải thiện hiệu suất và độ tin cậy của ứng dụng.
   - Trong bài lab, chúng ta sử dụng ALB để điều hướng yêu cầu đến các container ECS chứa ứng dụng web của chúng ta.

4. **AWS Secrets Manager**:
   - AWS Secrets Manager là một dịch vụ quản lý bảo mật cho phép lưu trữ và quản lý các bí mật như thông tin đăng nhập, khóa API và các thông tin quan trọng khác.
   - Trong bài lab, chúng ta sử dụng AWS Secrets Manager để lưu trữ thông tin kết nối đến cơ sở dữ liệu PostgreSQL một cách an toàn và bảo mật.

## Nội dung

{{% children  %}}