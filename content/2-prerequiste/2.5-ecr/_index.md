---
title: "Create Elastic Container Registry"
menuTitle: "ECR"
date :  "`r Sys.Date()`" 
weight : 5
chapter : false
pre : " <b> 2.5. </b> "
description: "Create an ECR Repository, build a Docker image, and then push it into the ECR Repository"
---

## Overview

{{% notice info %}}
Amazon Elastic Container Registry (ECR) is a service for managing and storing container images for use with Amazon ECS, Amazon EKS, or other services that use Docker containers. In this section, we will learn how to create and manage an ECR repository on AWS.
{{% /notice %}}

AWS provides two types of ECR repositories: public and private. However, in this lab, we will only work with public ECR repositories. To learn more about ECR Private Repositories, refer to [Amazon ECR private repositories](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html).

## Steps

In this section, we have created an ECR repository, authenticated Docker with ECR using the AWS CLI, pushed an image to ECR, and pulled an image from ECR.

1. Create an ECR Repository

    ```shell
    ecr_name=$docker_image_name
    # Create a new ECR repository
    aws ecr create-repository \
        --repository-name $ecr_name \
        --region $region \
        --tags "$tags"
    ```

2. Authentication with ECR: We need to authenticate Docker with ECR using the AWS CLI to interact with images on the repository.

    Use the following command to authenticate with the public registry (private registry will use a different method):

    ```shell
    aws ecr get-login-password \
        --region $region \
        | docker login \
        --username AWS \
        --password-stdin $aws_account_id.dkr.ecr.$region.amazonaws.com
    ```

    After successful authentication, you can verify the authentication information in the `~/.docker/config.json` file using the command:

    ```shell
    # Check Docker config file
    cat ~/.docker/config.json
    ```

3. Source code {{% button href="/source/workshop.zip" icon="fas fa-download" icon-position="right" %}}Download Source{{% /button %}}

    The source code is a project named **workshop** written in Java Spring Boot 3 with Maven running on port 8080, including two methods:
    * `GET /api/product`: Display the list of products.
    * `POST /api/product`: Add a product to the list.
    It uses PostgreSQL as the database and utilizes five environment variables to connect to the database: `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`, `POSTGRES_USERNAME`, and `POSTGRES_PASSWORD`.

4. Build a Docker image from source code

    Navigate to the directory containing the source code (unzip using the `unzip workshop.zip` command)

    ```shell
    docker build -t $ecr_name .
    # Check if the Docker image has been built successfully
    docker images --filter reference=$ecr_name
    ```

    The `docker build` command is used to create a Docker image, and the `docker images --filter` command is used to check if the Docker image has been created.

5. Tag the image: To push a Docker image to ECR, the image must be tagged in the format `aws_account_id.dkr.ecr.region.amazonaws.com/ecr_repository_name`.

    ```shell
    # Tag the image to push to your repository.
    docker tag $ecr_name:latest $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
    ```

6. Use the following command to push the image to ECR

    ```shell
    # Push to the AWS ECR repository
    docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
    ```

7. Pull an image from ECR: To pull an image from ECR, you need to specify the correct address of the ECR repository and the image tag to pull.

    ```shell
    # Pull an image from ECR
    docker pull $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name:latest
    ```

## Execution

1. Create an ECR Repository

    ![Create ECR via CLI](/images/2-prerequiste/2.5-ecr/2.5.1-create-ecr.png)

    The ECR repository has been successfully created

    ![Create ECR in the console](/images/2-prerequiste/2.5-ecr/2.5.2-created-ecr.png)

    | 👉 Click on **View push commands** to learn how to push an image to the ECR repository.

    ![View Push Command](/images/2-prerequiste/2.5-ecr/2.5.3-view-push-command.png)

2. Authentication with ECR

    ![Docker authenticate to ECR](/images/2-prerequiste/2.5-ecr/2.5.4-authen.png)

3. Source code

4. Build a Docker image from the source code

    ![Docker Build](/images/2-prerequiste/2.5-ecr/2.5.5-docker-build.png)

    ![Docker image filter](/images/2-prerequiste/2.5-ecr/2.5.6-docker-image.png)

5. Tag the image

    ![Docker Tag](/images/2-prerequiste/2.5-ecr/2.5.7-docker-tag.png)

6. Use the following command to push the image to ECR

    ![Docker push](/images/2-prerequiste/2.5-ecr/2.5.8-docker-push.png)

    The Docker Image has been successfully pushed to the ECR repository

    ![ECR Image](/images/2-prerequiste/2.5-ecr/2.5.9-ecr-image.png)

7. Pull an image from ECR

    ![Docker pull](/images/2-prerequiste/2.5-ecr/2.5.10-docker-pull.png)

## References

For more detailed information on how to create and push a Docker image to ECR using AWS CLI, refer to the AWS documentation: [Quick start: Publishing to Amazon ECR Public using the AWS CLI](https://docs.aws.amazon.com/AmazonECR/latest/public/getting-started-cli.html)

## Attached Documents

{{%attachments style="blue" /%}}