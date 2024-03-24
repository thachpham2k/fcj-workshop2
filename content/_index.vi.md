---
title : "Deploy ECS Application using AWS CLI"
date :  "`r Sys.Date()`" 
weight : 1 
chapter : false
---

# Triển khai Hệ thống AWS ECS với AWS CLI

## Tổng quan

Trong bài lab này, chúng ta sẽ triển khai một hệ thống trên AWS bằng cách sử dụng Command Line Interface (CLI) của AWS, bao gồm Application Load Balancer (ALB), Amazon ECS với các instance EC2 triển khai thông qua một nhóm Auto Scaling, AWS Secrets Manager để lưu trữ thông tin cơ sở dữ liệu, và Amazon RDS cho PostgreSQL.

Mặc dù không phổ biến trong các bài lab, việc sử dụng AWS CLI mang lại một trải nghiệm thú vị và hữu ích. Nó không chỉ giúp chúng ta làm quen với cách sử dụng AWS CLI và tìm hiểu các lệnh, mà còn cung cấp cái nhìn sâu hơn về cách hoạt động của các dịch vụ AWS. Điều này thực sự có giá trị khi ta muốn có kiến thức nền tảng rộng rãi và tự tin hơn khi triển khai và quản lý các dịch vụ trên AWS.

Kiến trúc:

![Kiến trúc](/images/diagram.png)

## Nội dung

{{% children  %}}