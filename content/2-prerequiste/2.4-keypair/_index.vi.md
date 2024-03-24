---
title : "Tạo EC2 Keypair"
menuTitle : "EC2 Keypair"
date : "`r Sys.Date()`"
weight : 4
chapter : false
pre : " <b> 2.4. </b> "
description: "Tạo Keypair cho AWS EC2"
---

## Tổng quan

{{% notice info %}}
A key pair, consisting of a public key and a private key, is a set of security credentials that you use to prove your identity when connecting to an Amazon EC2 instance. 
{{% /notice %}}

Nói cách khác thì AWS Key Pair chính là 1 cặp khóa public và private của **ssh key**. Có thể được tạo bởi AWS (cách chúng ta sẽ làm) hoặc bạn tự tạo thông qua lệnh tạo key của ssh `ssh-keygen` rồi upload lên AWS. Lúc này AWS sẽ giúp bạn thêm phần public key vào trong thư mục `~/.ssh` của đúng instance mà bạn sử dụng.

## Quy trình

Lệnh dưới đây được sử dụng để tạo keypair EC2 cho bài lab:

Tạo keypair bằng lệnh `aws ec2 create-key-pair`. Lệnh này sẽ trả về nội dung của tệp key, sau đó lưu nó vào một tệp có định dạng `*.pem` để sử dụng sau này.

Tuy nhiên, để sử dụng file key này thì phải cấu hình quyền
```shell
chmod 400 key.pem
```

> ❓ Tại sao phải chmod 400   
Khi kết nối vào một instance EC2 qua SSH, tệp khóa riêng tư (`*.pem`) cần có quyền truy cập được cài đặt chặt chẽ để đảm bảo an ninh (1 trong những điều kiện để trở thành **ssh key** là chỉ cho phép owner truy cập và sử dụng). Lệnh `chmod 400 key.pem` đặt quyền của tệp khóa thành chỉ có thể đọc được bởi chủ sở hữu (400 = 100 000 000), đảm bảo rằng không có người dùng nào khác trên hệ thống có thể truy cập được nó (ngoại trừ root user 😁 và owner). Điều này là cần thiết vì SSH sẽ từ chối sử dụng một tệp khóa riêng tư mà người dùng khác có thể truy cập.

```shell
ecs_instance_key_name=$project-keypair
# Tạo keypair
aws ec2 create-key-pair \
    --key-name $ecs_instance_key_name \
    --region $region \
    --tag-specifications `echo 'ResourceType=key-pair,Tags=['$tagspec` \
    --query 'KeyMaterial' \
    --output text > ./$ecs_instance_key_name.pem
```

## Thực hiện

1. Tạo Keypair

    ![Create Keypair](/images/2-prerequiste/2.4-keypair/2.4.1-create.png)

2. Kiểm tra keypair trên AWS Console

    ![keypair created](/images/2-prerequiste/2.4-keypair/2.4.2-keypair.png)