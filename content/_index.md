---
title: "Deploy ECS Application using AWS CLI"
date: "`r Sys.Date()`" 
weight: 1
chapter: false
---

# Deploying AWS ECS System with AWS CLI

## Overview

In this lab, we will deploy a system on AWS via AWS Command Line Interface (CLI), including an Application Load Balancer (ALB), Amazon ECS with EC2 instances deployed through an Auto Scaling group, AWS Secrets Manager to store database information, and Amazon RDS for PostgreSQL.

While not common in lab exercises, using the AWS CLI provides an interesting and useful experience. It not only helps us become familiar with using the AWS CLI and understanding commands but also provides a deeper insight into how AWS services work. This is truly valuable when we want to have broad foundational knowledge and be more confident in deploying and managing services on AWS.

Architecture:

![Architecture](/images/diagram.png)

## Content

{{% children  %}}