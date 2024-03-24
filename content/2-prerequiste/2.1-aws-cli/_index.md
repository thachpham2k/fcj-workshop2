---
title: "Installing and Configuring AWS CLI"
menuTitle: "AWS CLI"
date: "`r Sys.Date()`"
weight: 1
chapter: false
pre: "<b> 2.1. </b>"
description: "Guide to install and configure AWS CLI on your terminal"
---

## Overview

{{% notice info %}}
The AWS Command Line Interface (CLI) is a tool that allows you to interact with AWS services via the command line on your terminal.
{{% /notice %}}

Although AWS CLI is a command-line tool used on the terminal, it does not support **man pages**. So how do you look up commands?

- **On Terminal**: If you want to look up commands directly on the terminal, you can use:
  - The `help` keyword: Similar to **man pages**, AWS CLI will provide a list of commands, meanings, and much information related to the command you are looking for. The `help` keyword is not required to follow `aws`, you can place it anywhere you don't know what to write. For example: `aws s3 help`, `aws s3 ls help`,...
  - Sometimes the `help` keyword provides too much redundant information, and you just want to search for keywords without needing to explain the command, then you can use the `?` keyword. The `?` keyword will provide related keywords to the command you are searching for. For example: `aws ?`, `aws s3 ?`,.. The position of the `?` keyword is similar to when using the `help` keyword, however, the `?` keyword can only be placed where a command keyword should be placed. For example: you can use `aws s3 ?` but you can't use `aws s3 ls ?`.

- **Web Browser**: Although I prefer working with the terminal, I still find using the web for lookup is the easiest. The AWS CLI command lookup page provides very detailed information about the command such as description, options, variables, examples,... very easy to understand. The command lookup page is `https://docs.aws.amazon.com/cli/latest/`, if you want to look up commands related to S3 then it is `https://docs.aws.amazon.com/cli/latest/reference/s3`, if you want to see details about the `aws s3 ls` command then it is `https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html`. A tip when using it is after finding the command, you should go straight to the examples section to see how to use it, then go back to see its options. Give it a try, it might suit you too.

## Content

1. Install AWS CLI
    
    Use the following commands to install AWS CLI V2:

    ```shell
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    # Remove installation package
    rm -rf awscliv2.zip aws/install
    # Check AWS CLI version
    aws --version
    ```
    
    {{% notice note %}}
This guide only applies to the Linux operating system.   
For more information on installing AWS CLI on other platforms or updating AWS CLI to version 2, please [see here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    {{% /notice %}}
    
2. Configure AWS CLI

    To configure AWS CLI, we use the command:

    ```shell
    aws configure
    ```

    You need to enter 4 values: `Access Key ID`, `Secret Access Key`, `Region`, and `Default output format`.

    ![AWS CLI config](/images/2-prerequiste/2.1-aws-cli/2.1.1-cli-config.png)

    {{% notice note %}}
If you do not know or do not have AWS **Access Key** ID and **Secret Access Key**, please refer to the guide [Managing access keys for IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)   
To learn more about the `aws configure` command or encounter issues, please refer to the guide [Authenticate with IAM user credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html).    
Look up **AWS region code**: at [Regions and Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions)    
    {{% /notice %}}

    {{% notice tip %}}
After using the `aws configure` command, a folder named `.aws` will be created in the `~` directory (the user's home directory), including 2 files: `config` (containing information about the region and default output format) and `credentials` (containing Access Key ID and Secret Access Key). Instead of using `aws configure`, you can also use the following commands:
    {{% /notice %}}

    ```shell
    cat <<EOF | tee ~/.aws/config
    [default]
    region = ap-southeast-1
    output = json
    EOF
    cat <<EOF | tee ~/.aws/credentials
    [default]
    aws_access_key_id = abc
    aws_secret_access_key = abc
    EOF
    ```
    
3. Check Configuration

    In addition to configuring AWS CLI with the `aws configure` command, you can also use environment variables (PATH variables), ... so sometimes configuring with aws configure will not be accepted.
    
    After configuration, you should check again using the command:

    ```shell
    aws configure list
    ```

    | 👉 In the image below, although the `aws configure` command has configured the region as `ap-southeast-1`, AWS CLI still accepts the value `us-east-2` from the AWS_REGION variable.

    ![AWS Configure conflict](/images/2-prerequiste/2.1-aws-cli/2.1.2-bug.png)

## References

To learn more about AWS CLI: refer to the [aws cli document](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)