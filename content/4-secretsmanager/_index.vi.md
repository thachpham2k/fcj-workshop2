---
title: "Tạo Secrets Manager"
menuTitle: "Secrets Manager"
date: "`r Sys.Date()`"
weight: 4
chapter: false
pre: "<b> 4. </b>"
description: "Tạo và sử dụng Secret manager để lưu thông tin liên quan để DB Instance được ứng dụng sử dụng."
---

## Tổng quan

{{% notice info %}}
**AWS Secrets Manager** giúp bạn mã hóa, lưu trữ và lấy thông tin đăng nhập một cách an toàn cho các cơ sở dữ liệu và dịch vụ khác của bạn. Thay vì cứ mã hóa trực tiếp thông tin đăng nhập trong ứng dụng của bạn, bạn có thể gọi tới Secrets Manager để lấy thông tin đăng nhập mỗi khi cần. Secrets Manager giúp bảo vệ quyền truy cập vào tài nguyên và dữ liệu IT của bạn bằng cách cho phép bạn xoay vòng và quản lý quyền truy cập vào các bí mật của mình.
**AWS Secrets Manager** helps you to securely encrypt, store, and retrieve credentials for your databases and other services. Instead of hardcoding credentials in your apps, you can make calls to Secrets Manager to retrieve your credentials whenever needed. Secrets Manager helps you protect access to your IT resources and data by enabling you to rotate and manage access to your secrets.
{{% /notice %}}

## Quy trình

Tạo Secret Manager

Để Tạo Secret Manager, chúng ta sử dụng lệnh `aws secretsmanager create-secret` 

```shell
secret_name=$project-sm
secret_string=$(echo "{\"POSTGRES_HOST\":\"$rds_address\",\"POSTGRES_PORT\":\"5432\",\"POSTGRES_DB\":\"$rds_db_name\",\"POSTGRES_USERNAME\":\"$rds_db_username\",\"POSTGRES_PASSWORD\":\"$rds_db_password\"}")
# Create SecretManager
aws secretsmanager create-secret \
    --name $secret_name \
    --description "To save database information" \
    --tags "$tags" \
    --secret-string $secret_string
```

## Thực hiện

Tạo Secrets Manager

![Create Secrets Manager secret](/fcj-workshop2/images/4-secretsmanager/4.1.png)

Kiểm tra kết quả trên AWS Console

![Create Success](/fcj-workshop2/images/4-secretsmanager/4.2.png)

![Create Success](/fcj-workshop2/images/4-secretsmanager/4.3.png)

