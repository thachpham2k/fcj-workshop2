---
title : "Tạo Elastic Container Registry"
menuTitle: "ECR"
date :  "`r Sys.Date()`" 
weight : 5
chapter : false
pre : " <b> 2.5. </b> "
description: "Tạo ECR Registry, dựng docker image sau đó lưu lên trên ECR registry"
---

## Tổng quan

{{% notice info %}}
Amazon Elastic Container Registry (ECR) là dịch vụ quản lý và lưu trữ các container images cho việc sử dụng với Amazon ECS, Amazon EKS, hoặc các dịch vụ khác sử dụng Docker containers. Trong phần này, chúng ta sẽ tìm hiểu cách tạo và quản lý một repository ECR trên AWS.
{{% /notice %}}

AWS cung cấp 2 loại ECR repository là public và private. Nhưng trong bài lab mình chỉ làm việc với public ECR repository. Muốn tìm hiểu thêm về ECR Private Repository thì tham khảo tại [Amazon ECR private repositories](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html)

## Quy trình

Trong phần này, chúng ta đã tạo một ECR repository, đăng nhập vào ECR từ AWS CLI, push một image lên ECR, và pull một image từ ECR.

1. Tạo một ECR Repository

    ```shell
    ecr_name=$docker_image_name
    # Tạo repository ECR mới
    aws ecr create-repository \
        --repository-name $ecr_name \
        --region $region \
        --tags "$tags"
    ```

2. Xác thực đối với ECR: chúng ta cần xác thực đăng nhập vào ECR từ AWS CLI để có thể thao tác với image trên repository.

    Sử dụng lệnh sau để xác thực với public registry (private registry sẽ sử dụng cách khác)

    ```shell
    aws ecr get-login-password \
        --region $region \
        | docker login \
        --username AWS \
        --password-stdin $aws_account_id.dkr.ecr.$region.amazonaws.com
    ```

    Sau khi xác thực thành công có thể kiểm tra thông tin xác thực trong file `~/.docker/config.json`. Sử dụng lệnh

    ```shell
    # Kiểm tra tệp config Docker
    cat ~/.docker/config.json
    ```

3. Source code {{% button href="/source/workshop.zip" icon="fas fa-download" icon-position="right" %}}Download Source{{% /button %}}

    Source code là một project có tên **workshop** được viết bằng Java Spring Boot 3 kết hợp với Maven chạy trên cổng 8080, bao gồm 2 phương thức:
    * `GET /api/product`: Hiển thị danh sách sản phẩm.
    * `POST /api/product`: Thêm sản phẩm vào danh sách.
    Sử dụng PostgreSQL là database và sử dụng 5 biến môi trường để kết nối đến database là `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`, `POSTGRES_USERNAME`, và `POSTGRES_PASSWORD`.

4. Tạo Docker image từ source code

    Đến thư mục chứa source code (giải nén bằng lênh `unzip workshop.zip`)

    ```shell
    docker build -t $ecr_name .
    # Kiểm tra Docker image đã được tạo đúng chưa
    docker images --filter reference=$ecr_name
    ```
    
    Lệnh `docker build` dùng để tạo docker image, lệnh `docker images --filter` dùng để kiểm tra xem docker image đã được tạo hay chưa.

5. Đặt tag cho image: Để có thể push docker image lên ECR, image phải được đặt tag với định dạng `aws_account_id.dkr.ecr.region.amazonaws.com/ecr_repository_name`.
    
    ```shell
    # Đặt tag cho image để push vào repository của bạn.
    docker tag $ecr_name:latest $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
    ```

6. Sử dụng lệnh sau để push image lên ECR

    ```shell
    # Push to AWS ECR repository
    docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
    ```

7. Pull image từ ECR: Để pull một image từ ECR, bạn cần chỉ định đúng địa chỉ của repository ECR và tag của image cần pull.

    ```shell
    # Pull image từ ECR
    docker pull $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name:latest
    ```

## Thực hiện

1. Tạo một ECR Repository

    ![Create ECR via cli](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.1-create-ecr.png)

    ECR repository đã được tạo thành công

    ![Create ECR in console](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.2-created-ecr.png)

    | 👉 Chọn vào **View push commands**, bạn sẽ được hướng dẫn làm sao để push một image lên ECR repository.

    ![View Push Command](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.3-view-push-command.png)

2. Xác thực đối với ECR

    ![Docker authenticate to ECR](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.4-authen.png)

3. Source code

4. Tạo Docker image từ source code

    ![Docker Build](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.5-docker-build.png)

    ![Docker image filter](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.6-docker-image.png)

5. Đặt tag cho image

    ![Docker Tag](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.7-docker-tag.png)

6. Sử dụng lệnh sau để push image lên ECR

    ![Docker push](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.8-docker-push.png)

    Docker Image đã được đẩy lên ECR repository thành công

    ![ECR Image](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.9-ecr-image.png)

7. Pull image từ ECR

    ![Docker pull](/fcj-workshop2/images/2-prerequiste/2.5-ecr/2.5.10-docker-pull.png)

## Tham khảo

Tìm hiểu chi tiết hơn về cách tạo và đẩy một docker iamge lên ECR bằng AWS cli: tham khảo tài liệu của AWS: [Quick start: Publishing to Amazon ECR Public using the AWS CLI](https://docs.aws.amazon.com/AmazonECR/latest/public/getting-started-cli.html)

## Tài liệu đính kèm

{{%attachments style="blue" /%}}