---
title: "Create Secrets Manager"
menuTitle: "Secrets Manager"
date: "`r Sys.Date()`"
weight: 4
chapter: false
pre: "<b> 4. </b>"
description: "Creating and using Secrets Manager to store relevant information for DB Instance used in application"
---

## Overview

{{% notice info %}}
**AWS Secrets Manager** helps you to securely encrypt, store, and retrieve credentials for your databases and other services. Instead of hardcoding credentials in your apps, you can make calls to Secrets Manager to retrieve your credentials whenever needed. Secrets Manager helps you protect access to your IT resources and data by enabling you to rotate and manage access to your secrets.
{{% /notice %}}

## Steps

Create Secrets Manager

To create a Secrets Manager, we use the `aws secretsmanager create-secret` command.

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

## Execution

Create Secrets Manager

![Create Secrets Manager secret](/images/4-secretsmanager/4.1.png)

Check the result on the AWS Console

![Create Success](/images/4-secretsmanager/4.2.png)

![Create Success](/images/4-secretsmanager/4.3.png)