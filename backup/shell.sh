  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo hello
hello
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws --version
aws-cli/2.13.14 Python/3.11.4 Linux/5.15.146.1-microsoft-standard-WSL2 exe/x86_64.ubuntu.22 prompt/off
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws configure
AWS Access Key ID [****************HNLO]:
AWS Secret Access Key [****************4wLA]:
Default region name [ap-southeast-1]:
Default output format [json]:
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************HNLO shared-credentials-file
secret_key     ****************4wLA shared-credentials-file
    region           ap-southeast-1      config-file    ~/.aws/config
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "============ terminal config"
============ terminal config
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ # project
project=workshop2
# global architect
region=ap-southeast-1
az_01=${region}a
az_02=${region}b
az_03=${region}c
# tags
tags='[{"Key":"purpose", "Value":"workshop2"}, {"Key":"project", "Value":"fcj_workshop"}, {"Key":"author", "Value":"pthach_cli"}]'
tags2='[{"key":"purpose", "value":"workshop2"}, {"key":"project", "value":"fcj_workshop"}, {"key":"author", "value":"pthach_cli"}]'
tagspec='{Key=purpose,Value=workshop2},{Key=project,Value=fcj_workshop},{Key=author,Value=pthach_cli}]'
# Identity
aws_account_id=$(aws sts get-caller-identity --query 'Account' --output text)
# ecr
docker_image_name=container-image
ecr_image_uri=$aws_account_id.dkr.ecr.$region.amazonaws.com/${docker_image_name}:latest
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo project=$project
echo region=$region
echo az_01=$az_01
echo az_02=$az_02
echo az_03=$az_03
echo tags=$tags
echo tags2=$tags2
echo tagspec=$tagspec
echo aws_account_id=$aws_account_id

echo docker_image_name=$docker_image_name
echo ecr_image_uri=$ecr_image_uri
echo "==="
project=workshop2
region=ap-southeast-1
az_01=ap-southeast-1a
az_02=ap-southeast-1b
az_03=ap-southeast-1c
tags=[{"Key":"purpose", "Value":"workshop2"}, {"Key":"project", "Value":"fcj_workshop"}, {"Key":"author", "Value":"pthach_cli"}]
tags2=[{"key":"purpose", "value":"workshop2"}, {"key":"project", "value":"fcj_workshop"}, {"key":"author", "value":"pthach_cli"}]
tagspec={Key=purpose,Value=workshop2},{Key=project,Value=fcj_workshop},{Key=author,Value=pthach_cli}]
aws_account_id=aws_account_id
docker_image_name=container-image
ecr_image_uri=aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest
===
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "================2.3 iam"
================2.3 iam
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_role_name=$project-ecs-instance-role
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_role_name=$ecs_instance_role_name
ecs_instance_role_name=workshop2-ecs-instance-role
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam create-role \
    --role-name $ecs_instance_role_name \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "Service": ["ec2.amazonaws.com"]
            },
            "Action": ["sts:AssumeRole"]
        }]
    }' \
    --tags "$tags"
{
    "Role": {
        "Path": "/",
        "RoleName": "workshop2-ecs-instance-role",
        "RoleId": "AROA5J6F46N4XASEMOBBF",
        "Arn": "arn:aws:iam::aws_account_id:role/workshop2-ecs-instance-role",
        "CreateDate": "2024-03-18T08:40:12+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": [
                            "ec2.amazonaws.com"
                        ]
                    },
                    "Action": [
                        "sts:AssumeRole"
                    ]
                }
            ]
        },
        "Tags": [
            {
                "Key": "purpose",
                "Value": "workshop2"
            },
            {
                "Key": "project",
                "Value": "fcj_workshop"
            },
            {
                "Key": "author",
                "Value": "pthach_cli"
            }
        ]
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
    --role-name $ecs_instance_role_name

aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
    --role-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam create-instance-profile \
    --instance-profile-name $ecs_instance_role_name
{
    "InstanceProfile": {
        "Path": "/",
        "InstanceProfileName": "workshop2-ecs-instance-role",
        "InstanceProfileId": "AIPA5J6F46N42ZLBKQPUS",
        "Arn": "arn:aws:iam::aws_account_id:instance-profile/workshop2-ecs-instance-role",
        "CreateDate": "2024-03-18T08:46:00+00:00",
        "Roles": []
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam add-role-to-instance-profile \
    --instance-profile-name $ecs_instance_role_name \
    --role-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_profile_arn=$(aws iam get-instance-profile \
    --instance-profile-name $ecs_instance_role_name \
    --output text \
    --query 'InstanceProfile.Arn')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_profile_arn=$ecs_instance_profile_arn
ecs_instance_profile_arn=arn:aws:iam::aws_account_id:instance-profile/workshop2-ecs-instance-role
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "================ keypair"
================ keypair
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_key_name=$project-keypair
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_key_name=$ecs_instance_key_name
echo region=$region
ecs_instance_key_name=workshop2-keypair
region=ap-southeast-1
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-key-pair \
    --key-name $ecs_instance_key_name \
    --region $region \
    --tag-specifications `echo 'ResourceType=key-pair,Tags=['$tagspec` \
    --query 'KeyMaterial' \
    --output text > ./$ecs_instance_key_name.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "==========ecr"
==========ecr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecr_name=$docker_image_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecr_name=$ecr_name
ecr_name=container-image
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecr create-repository \
    --repository-name $ecr_name \
    --region $region \
    --tags "$tags"
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:ap-southeast-1:aws_account_id:repository/container-image",
        "registryId": "aws_account_id",
        "repositoryName": "container-image",
        "repositoryUri": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image",
        "createdAt": "2024-03-18T15:54:11.095000+07:00",
        "imageTagMutability": "MUTABLE",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "encryptionConfiguration": {
            "encryptionType": "AES256"
        }
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecr get-login-password \
        --region $region \
        | docker login \
        --username AWS \
        --password-stdin $aws_account_id.dkr.ecr.$region.amazonaws.com
WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat ~/.docker/config.json
{
        "auths": {
                "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com": {
                        "auth": "abc"
                }
        }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cd ../workshop2
  ubuntu@thachpham  ~/firtcloudjourney/workshop2  $ docker images --filter reference=$ecr_name
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
  ubuntu@thachpham  ~/firtcloudjourney/workshop2  $ docker build -t $ecr_name .
Sending build context to Docker daemon  24.58kB
Step 1/11 : FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
3.9.6-eclipse-temurin-17-alpine: Pulling from library/maven
4abcf2066143: Pull complete
3d6fa00702eb: Pull complete
dc145c2c40b0: Pull complete
65413771e18c: Pull complete
80f39855dd57: Pull complete
edc91b292e82: Pull complete                                                                                                                                                e5cf00d6a697: Pull complete
8496f2e299bd: Pull complete
38a28dcf9bf4: Pull complete
8aba5aded68c: Pull complete
Digest: sha256:5c3abd43b7e977841fffda996396cf31faf3cea78ff644d16029095921a9fe05
Status: Downloaded newer image for maven:3.9.6-eclipse-temurin-17-alpine
 ---> 05532906c77c
Step 2/11 : WORKDIR /app
 ---> Running in 25f7d3dd8543
Removing intermediate container 25f7d3dd8543
 ---> fcc53215f29e
Step 3/11 : COPY pom.xml .
 ---> 5dd5228a0a93
Step 4/11 : RUN mvn dependency:go-offline -B
 ---> Running in 6b68072017df
[INFO] Scanning for projects...
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-parent/3.2.3/spring-boot-starter-parent-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-parent/3.2.3/spring-boot-starter-parent-3.2.3.pom (13 kB at 24 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-dependencies/3.2.3/spring-boot-dependencies-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-dependencies/3.2.3/spring-boot-dependencies-3.2.3.pom (111 kB at 633 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-bom/3.24.2/assertj-bom-3.24.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-bom/3.24.2/assertj-bom-3.24.2.pom (3.7 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/zipkin/brave/brave-bom/5.16.0/brave-bom-5.16.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/zipkin/brave/brave-bom/5.16.0/brave-bom-5.16.0.pom (12 kB at 187 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/zipkin/reporter2/zipkin-reporter-bom/2.16.3/zipkin-reporter-bom-2.16.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/zipkin/reporter2/zipkin-reporter-bom/2.16.3/zipkin-reporter-bom-2.16.3.pom (6.9 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/datastax/oss/java-driver-bom/4.17.0/java-driver-bom-4.17.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/datastax/oss/java-driver-bom/4.17.0/java-driver-bom-4.17.0.pom (4.1 kB at 74 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/dropwizard/metrics/metrics-bom/4.2.25/metrics-bom-4.2.25.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/dropwizard/metrics/metrics-bom/4.2.25/metrics-bom-4.2.25.pom (8.2 kB at 144 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/dropwizard/metrics/metrics-parent/4.2.25/metrics-parent-4.2.25.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/dropwizard/metrics/metrics-parent/4.2.25/metrics-parent-4.2.25.pom (21 kB at 363 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-bom/4.0.4/jaxb-bom-4.0.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-bom/4.0.4/jaxb-bom-4.0.4.pom (12 kB at 195 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/ee4j/project/1.0.8/project-1.0.8.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/ee4j/project/1.0.8/project-1.0.8.pom (15 kB at 260 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/groovy/groovy-bom/4.0.18/groovy-bom-4.0.18.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/groovy/groovy-bom/4.0.18/groovy-bom-4.0.18.pom (27 kB at 390 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-bom/14.0.24.Final/infinispan-bom-14.0.24.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-bom/14.0.24.Final/infinispan-bom-14.0.24.Final.pom (24 kB at 339 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-build-configuration-parent/14.0.24.Final/infinispan-build-configuration-parent-14.0.24.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-build-configuration-parent/14.0.24.Final/infinispan-build-configuration-parent-14.0.24.Final.pom (24 kB at 376 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/jboss-parent/39/jboss-parent-39.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/jboss-parent/39/jboss-parent-39.pom (68 kB at 580 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.15.4/jackson-bom-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.15.4/jackson-bom-2.15.4.pom (18 kB at 269 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-parent/2.15/jackson-parent-2.15.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-parent/2.15/jackson-parent-2.15.pom (6.5 kB at 112 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/50/oss-parent-50.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/50/oss-parent-50.pom (24 kB at 347 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jersey/jersey-bom/3.1.5/jersey-bom-3.1.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jersey/jersey-bom/3.1.5/jersey-bom-3.1.5.pom (21 kB at 324 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/ee10/jetty-ee10-bom/12.0.6/jetty-ee10-bom-12.0.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/ee10/jetty-ee10-bom/12.0.6/jetty-ee10-bom-12.0.6.pom (9.2 kB at 157 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-bom/12.0.6/jetty-bom-12.0.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-bom/12.0.6/jetty-bom-12.0.6.pom (14 kB at 231 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.10.2/junit-bom-5.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.10.2/junit-bom-5.10.2.pom (5.6 kB at 97 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-bom/1.9.22/kotlin-bom-1.9.22.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-bom/1.9.22/kotlin-bom-1.9.22.pom (9.1 kB at 134 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlinx/kotlinx-coroutines-bom/1.7.3/kotlinx-coroutines-bom-1.7.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlinx/kotlinx-coroutines-bom/1.7.3/kotlinx-coroutines-bom-1.7.3.pom (4.3 kB at 79 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlinx/kotlinx-serialization-bom/1.6.3/kotlinx-serialization-bom-1.6.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlinx/kotlinx-serialization-bom/1.6.3/kotlinx-serialization-bom-1.6.3.pom (3.7 kB at 64 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-bom/2.21.1/log4j-bom-2.21.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-bom/2.21.1/log4j-bom-2.21.1.pom (12 kB at 204 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/logging-parent/10.1.1/logging-parent-10.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/logging-parent/10.1.1/logging-parent-10.1.1.pom (39 kB at 190 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/30/apache-30.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/30/apache-30.pom (23 kB at 298 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-bom/1.12.3/micrometer-bom-1.12.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-bom/1.12.3/micrometer-bom-1.12.3.pom (7.9 kB at 136 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-tracing-bom/1.2.3/micrometer-tracing-bom-1.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-tracing-bom/1.2.3/micrometer-tracing-bom-1.2.3.pom (4.7 kB at 83 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-bom/5.7.0/mockito-bom-5.7.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-bom/5.7.0/mockito-bom-5.7.0.pom (3.0 kB at 51 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/netty/netty-bom/4.1.107.Final/netty-bom-4.1.107.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/netty/netty-bom/4.1.107.Final/netty-bom-4.1.107.Final.pom (14 kB at 225 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/oss/oss-parent/7/oss-parent-7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/oss/oss-parent/7/oss-parent-7.pom (4.8 kB at 91 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp-bom/4.12.0/okhttp-bom-4.12.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp-bom/4.12.0/okhttp-bom-4.12.0.pom (3.1 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/opentelemetry/opentelemetry-bom/1.31.0/opentelemetry-bom-1.31.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/opentelemetry/opentelemetry-bom/1.31.0/opentelemetry-bom-1.31.0.pom (7.0 kB at 127 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/oracle/database/jdbc/ojdbc-bom/21.9.0.0/ojdbc-bom-21.9.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/oracle/database/jdbc/ojdbc-bom/21.9.0.0/ojdbc-bom-21.9.0.0.pom (13 kB at 226 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_bom/0.16.0/simpleclient_bom-0.16.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_bom/0.16.0/simpleclient_bom-0.16.0.pom (6.0 kB at 109 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/prometheus/parent/0.16.0/parent-0.16.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/prometheus/parent/0.16.0/parent-0.16.0.pom (13 kB at 220 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/querydsl/querydsl-bom/5.0.0/querydsl-bom-5.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/querydsl/querydsl-bom/5.0.0/querydsl-bom-5.0.0.pom (7.2 kB at 130 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/projectreactor/reactor-bom/2023.0.3/reactor-bom-2023.0.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/projectreactor/reactor-bom/2023.0.3/reactor-bom-2023.0.3.pom (4.8 kB at 87 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/rest-assured/rest-assured-bom/5.3.2/rest-assured-bom-5.3.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/rest-assured/rest-assured-bom/5.3.2/rest-assured-bom-5.3.2.pom (4.3 kB at 79 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/rsocket/rsocket-bom/1.1.3/rsocket-bom-1.1.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/rsocket/rsocket-bom/1.1.3/rsocket-bom-1.1.3.pom (2.6 kB at 48 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/seleniumhq/selenium/selenium-bom/4.14.1/selenium-bom-4.14.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/seleniumhq/selenium/selenium-bom/4.14.1/selenium-bom-4.14.1.pom (6.0 kB at 116 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/amqp/spring-amqp-bom/3.1.2/spring-amqp-bom-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/amqp/spring-amqp-bom/3.1.2/spring-amqp-bom-3.1.2.pom (3.9 kB at 74 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/batch/spring-batch-bom/5.1.1/spring-batch-bom-5.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/batch/spring-batch-bom/5.1.1/spring-batch-bom-5.1.1.pom (3.2 kB at 61 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-bom/2023.1.3/spring-data-bom-2023.1.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-bom/2023.1.3/spring-data-bom-2023.1.3.pom (5.5 kB at 104 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-framework-bom/6.1.4/spring-framework-bom-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-framework-bom/6.1.4/spring-framework-bom-6.1.4.pom (5.8 kB at 108 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/integration/spring-integration-bom/6.2.2/spring-integration-bom-6.2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/integration/spring-integration-bom/6.2.2/spring-integration-bom-6.2.2.pom (10 kB at 159 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/pulsar/spring-pulsar-bom/1.0.3/spring-pulsar-bom-1.0.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/pulsar/spring-pulsar-bom/1.0.3/spring-pulsar-bom-1.0.3.pom (2.7 kB at 51 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/restdocs/spring-restdocs-bom/3.0.1/spring-restdocs-bom-3.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/restdocs/spring-restdocs-bom/3.0.1/spring-restdocs-bom-3.0.1.pom (2.6 kB at 51 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/security/spring-security-bom/6.2.2/spring-security-bom-6.2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/security/spring-security-bom/6.2.2/spring-security-bom-6.2.2.pom (5.3 kB at 97 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/session/spring-session-bom/3.2.1/spring-session-bom-3.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/session/spring-session-bom/3.2.1/spring-session-bom-3.2.1.pom (2.9 kB at 57 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/ws/spring-ws-bom/4.0.10/spring-ws-bom-4.0.10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/ws/spring-ws-bom/4.0.10/spring-ws-bom-4.0.10.pom (3.5 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/testcontainers/testcontainers-bom/1.19.5/testcontainers-bom-1.19.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/testcontainers/testcontainers-bom/1.19.5/testcontainers-bom-1.19.5.pom (9.1 kB at 166 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-maven-plugin/3.2.3/spring-boot-maven-plugin-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-maven-plugin/3.2.3/spring-boot-maven-plugin-3.2.3.pom (4.0 kB at 77 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-maven-plugin/3.2.3/spring-boot-maven-plugin-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-maven-plugin/3.2.3/spring-boot-maven-plugin-3.2.3.jar (134 kB at 858 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-clean-plugin/3.3.2/maven-clean-plugin-3.3.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-clean-plugin/3.3.2/maven-clean-plugin-3.3.2.pom (5.3 kB at 99 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/40/maven-plugins-40.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/40/maven-plugins-40.pom (8.1 kB at 150 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/40/maven-parent-40.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/40/maven-parent-40.pom (49 kB at 504 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-clean-plugin/3.3.2/maven-clean-plugin-3.3.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-clean-plugin/3.3.2/maven-clean-plugin-3.3.2.jar (36 kB at 422 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.3.1/maven-resources-plugin-3.3.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.3.1/maven-resources-plugin-3.3.1.pom (8.2 kB at 129 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/39/maven-plugins-39.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/39/maven-plugins-39.pom (8.1 kB at 137 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/39/maven-parent-39.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/39/maven-parent-39.pom (48 kB at 592 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/29/apache-29.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/29/apache-29.pom (21 kB at 324 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.3.1/maven-resources-plugin-3.3.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.3.1/maven-resources-plugin-3.3.1.jar (31 kB at 360 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-jar-plugin/3.3.0/maven-jar-plugin-3.3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-jar-plugin/3.3.0/maven-jar-plugin-3.3.0.pom (6.8 kB at 115 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/37/maven-plugins-37.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/37/maven-plugins-37.pom (9.9 kB at 174 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/37/maven-parent-37.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/37/maven-parent-37.pom (46 kB at 518 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/27/apache-27.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/27/apache-27.pom (20 kB at 323 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-jar-plugin/3.3.0/maven-jar-plugin-3.3.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-jar-plugin/3.3.0/maven-jar-plugin-3.3.0.jar (27 kB at 396 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.11.0/maven-compiler-plugin-3.11.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.11.0/maven-compiler-plugin-3.11.0.pom (9.8 kB at 175 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.11.0/maven-compiler-plugin-3.11.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.11.0/maven-compiler-plugin-3.11.0.jar (66 kB at 576 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-surefire-plugin/3.1.2/maven-surefire-plugin-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-surefire-plugin/3.1.2/maven-surefire-plugin-3.1.2.pom (5.5 kB at 99 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire/3.1.2/surefire-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire/3.1.2/surefire-3.1.2.pom (22 kB at 330 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-surefire-plugin/3.1.2/maven-surefire-plugin-3.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-surefire-plugin/3.1.2/maven-surefire-plugin-3.1.2.jar (43 kB at 461 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-install-plugin/3.1.1/maven-install-plugin-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-install-plugin/3.1.1/maven-install-plugin-3.1.1.pom (7.8 kB at 145 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-install-plugin/3.1.1/maven-install-plugin-3.1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-install-plugin/3.1.1/maven-install-plugin-3.1.1.jar (31 kB at 422 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-deploy-plugin/3.1.1/maven-deploy-plugin-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-deploy-plugin/3.1.1/maven-deploy-plugin-3.1.1.pom (8.9 kB at 155 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-deploy-plugin/3.1.1/maven-deploy-plugin-3.1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-deploy-plugin/3.1.1/maven-deploy-plugin-3.1.1.jar (39 kB at 329 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-site-plugin/3.12.1/maven-site-plugin-3.12.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-site-plugin/3.12.1/maven-site-plugin-3.12.1.pom (20 kB at 258 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/36/maven-plugins-36.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/36/maven-plugins-36.pom (9.9 kB at 157 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/36/maven-parent-36.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/36/maven-parent-36.pom (45 kB at 568 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/26/apache-26.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/26/apache-26.pom (21 kB at 326 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-site-plugin/3.12.1/maven-site-plugin-3.12.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-site-plugin/3.12.1/maven-site-plugin-3.12.1.jar (119 kB at 550 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/mojo/build-helper-maven-plugin/3.4.0/build-helper-maven-plugin-3.4.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/mojo/build-helper-maven-plugin/3.4.0/build-helper-maven-plugin-3.4.0.pom (7.6 kB at 139 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/mojo/mojo-parent/74/mojo-parent-74.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/mojo/mojo-parent/74/mojo-parent-74.pom (36 kB at 457 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.9.2/junit-bom-5.9.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.9.2/junit-bom-5.9.2.pom (5.6 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/mojo/build-helper-maven-plugin/3.4.0/build-helper-maven-plugin-3.4.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/mojo/build-helper-maven-plugin/3.4.0/build-helper-maven-plugin-3.4.0.jar (70 kB at 689 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/flywaydb/flyway-maven-plugin/9.22.3/flyway-maven-plugin-9.22.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/flywaydb/flyway-maven-plugin/9.22.3/flyway-maven-plugin-9.22.3.pom (4.4 kB at 81 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/flywaydb/flyway-parent/9.22.3/flyway-parent-9.22.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/flywaydb/flyway-parent/9.22.3/flyway-parent-9.22.3.pom (35 kB at 471 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/flywaydb/flyway-maven-plugin/9.22.3/flyway-maven-plugin-9.22.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/flywaydb/flyway-maven-plugin/9.22.3/flyway-maven-plugin-9.22.3.jar (112 kB at 789 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/github/git-commit-id/git-commit-id-maven-plugin/6.0.0/git-commit-id-maven-plugin-6.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/github/git-commit-id/git-commit-id-maven-plugin/6.0.0/git-commit-id-maven-plugin-6.0.0.pom (25 kB at 347 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/oss/oss-parent/9/oss-parent-9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/oss/oss-parent/9/oss-parent-9.pom (6.6 kB at 113 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/github/git-commit-id/git-commit-id-maven-plugin/6.0.0/git-commit-id-maven-plugin-6.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/github/git-commit-id/git-commit-id-maven-plugin/6.0.0/git-commit-id-maven-plugin-6.0.0.jar (56 kB at 616 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jooq/jooq-codegen-maven/3.18.11/jooq-codegen-maven-3.18.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jooq/jooq-codegen-maven/3.18.11/jooq-codegen-maven-3.18.11.pom (4.5 kB at 87 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jooq/jooq-parent/3.18.11/jooq-parent-3.18.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jooq/jooq-parent/3.18.11/jooq-parent-3.18.11.pom (38 kB at 518 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jooq/jooq-codegen-maven/3.18.11/jooq-codegen-maven-3.18.11.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jooq/jooq-codegen-maven/3.18.11/jooq-codegen-maven-3.18.11.jar (18 kB at 299 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-maven-plugin/1.9.22/kotlin-maven-plugin-1.9.22.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-maven-plugin/1.9.22/kotlin-maven-plugin-1.9.22.pom (6.7 kB at 131 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-project/1.9.22/kotlin-project-1.9.22.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-project/1.9.22/kotlin-project-1.9.22.pom (16 kB at 260 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-maven-plugin/1.9.22/kotlin-maven-plugin-1.9.22.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-maven-plugin/1.9.22/kotlin-maven-plugin-1.9.22.jar (82 kB at 800 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/liquibase/liquibase-maven-plugin/4.24.0/liquibase-maven-plugin-4.24.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/liquibase/liquibase-maven-plugin/4.24.0/liquibase-maven-plugin-4.24.0.pom (2.0 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/liquibase/liquibase-maven-plugin/4.24.0/liquibase-maven-plugin-4.24.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/liquibase/liquibase-maven-plugin/4.24.0/liquibase-maven-plugin-4.24.0.jar (161 kB at 1.1 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-antrun-plugin/3.1.0/maven-antrun-plugin-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-antrun-plugin/3.1.0/maven-antrun-plugin-3.1.0.pom (9.1 kB at 169 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/34/maven-plugins-34.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-plugins/34/maven-plugins-34.pom (11 kB at 202 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/34/maven-parent-34.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/34/maven-parent-34.pom (43 kB at 487 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/23/apache-23.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/23/apache-23.pom (18 kB at 312 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-antrun-plugin/3.1.0/maven-antrun-plugin-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-antrun-plugin/3.1.0/maven-antrun-plugin-3.1.0.jar (41 kB at 565 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-assembly-plugin/3.6.0/maven-assembly-plugin-3.6.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-assembly-plugin/3.6.0/maven-assembly-plugin-3.6.0.pom (15 kB at 217 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-assembly-plugin/3.6.0/maven-assembly-plugin-3.6.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-assembly-plugin/3.6.0/maven-assembly-plugin-3.6.0.jar (236 kB at 938 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-dependency-plugin/3.6.1/maven-dependency-plugin-3.6.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-dependency-plugin/3.6.1/maven-dependency-plugin-3.6.1.pom (18 kB at 255 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-dependency-plugin/3.6.1/maven-dependency-plugin-3.6.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-dependency-plugin/3.6.1/maven-dependency-plugin-3.6.1.jar (191 kB at 867 kB/s)
[INFO]
[INFO] -----------------------< com.workshop:workshop2 >-----------------------
[INFO] Building workshop2 0.0.1-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] --- dependency:3.6.1:go-offline (default-cli) @ workshop2 ---
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sink-api/1.11.1/doxia-sink-api-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sink-api/1.11.1/doxia-sink-api-1.11.1.pom (1.6 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia/1.11.1/doxia-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia/1.11.1/doxia-1.11.1.pom (18 kB at 282 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-logging-api/1.11.1/doxia-logging-api-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-logging-api/1.11.1/doxia-logging-api-1.11.1.pom (1.6 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.1.1/maven-reporting-api-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.1.1/maven-reporting-api-3.1.1.pom (3.8 kB at 71 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/34/maven-shared-components-34.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/34/maven-shared-components-34.pom (5.1 kB at 94 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-impl/3.2.0/maven-reporting-impl-3.2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-impl/3.2.0/maven-reporting-impl-3.2.0.pom (7.6 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.1.0/maven-core-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.1.0/maven-core-3.1.0.pom (6.9 kB at 133 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.1.0/maven-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.1.0/maven-3.1.0.pom (22 kB at 357 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/23/maven-parent-23.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/23/maven-parent-23.pom (33 kB at 486 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/13/apache-13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/13/apache-13.pom (14 kB at 218 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.1.0/maven-model-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.1.0/maven-model-3.1.0.pom (3.8 kB at 76 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/4.0.0/plexus-utils-4.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/4.0.0/plexus-utils-4.0.0.pom (8.7 kB at 163 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/13/plexus-13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/13/plexus-13.pom (27 kB at 428 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.9.3/junit-bom-5.9.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.9.3/junit-bom-5.9.3.pom (5.6 kB at 95 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.1.0/maven-settings-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.1.0/maven-settings-3.1.0.pom (1.8 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.1.0/maven-settings-builder-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.1.0/maven-settings-builder-3.1.0.pom (2.3 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.16/plexus-interpolation-1.16.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.16/plexus-interpolation-1.16.pom (1.0 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.3/plexus-components-1.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.3/plexus-components-1.3.pom (3.1 kB at 60 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/3.3/plexus-3.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/3.3/plexus-3.3.pom (20 kB at 326 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/spice/spice-parent/17/spice-parent-17.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/spice/spice-parent/17/spice-parent-17.pom (6.8 kB at 133 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/10/forge-parent-10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/10/forge-parent-10.pom (14 kB at 222 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.5/plexus-component-annotations-1.5.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.5/plexus-component-annotations-1.5.5.pom (815 B at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.5.5/plexus-containers-1.5.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.5.5/plexus-containers-1.5.5.pom (4.2 kB at 87 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.7/plexus-2.0.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.7/plexus-2.0.7.pom (17 kB at 303 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-sec-dispatcher/1.3/plexus-sec-dispatcher-1.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-sec-dispatcher/1.3/plexus-sec-dispatcher-1.3.pom (3.0 kB at 62 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/spice/spice-parent/12/spice-parent-12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/spice/spice-parent/12/spice-parent-12.pom (6.8 kB at 111 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/4/forge-parent-4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/4/forge-parent-4.pom (8.4 kB at 165 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.pom (2.1 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.pom (1.9 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.1.0/maven-artifact-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.1.0/maven-artifact-3.1.0.pom (1.6 kB at 30 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.0/maven-plugin-api-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.0/maven-plugin-api-3.1.0.pom (3.0 kB at 63 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.0.M1/org.eclipse.sisu.plexus-0.3.0.M1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.0.M1/org.eclipse.sisu.plexus-0.3.0.M1.pom (4.7 kB at 94 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-plexus/0.3.0.M1/sisu-plexus-0.3.0.M1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-plexus/0.3.0.M1/sisu-plexus-0.3.0.M1.pom (13 kB at 245 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.0/cdi-api-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.0/cdi-api-1.0.pom (1.4 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-api-parent/1.0/weld-api-parent-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-api-parent/1.0/weld-api-parent-1.0.pom (2.4 kB at 49 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-api-bom/1.0/weld-api-bom-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-api-bom/1.0/weld-api-bom-1.0.pom (7.9 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-parent/6/weld-parent-6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-parent/6/weld-parent-6.pom (21 kB at 328 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/annotation/jsr250-api/1.0/jsr250-api-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/annotation/jsr250-api/1.0/jsr250-api-1.0.pom (1.0 kB at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/inject/javax.inject/1/javax.inject-1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/inject/javax.inject/1/javax.inject-1.pom (612 B at 13 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.0.M1/org.eclipse.sisu.inject-0.3.0.M1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.0.M1/org.eclipse.sisu.inject-0.3.0.M1.pom (2.5 kB at 51 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-inject/0.3.0.M1/sisu-inject-0.3.0.M1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-inject/0.3.0.M1/sisu-inject-0.3.0.M1.pom (14 kB at 255 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.1/plexus-classworlds-2.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.1/plexus-classworlds-2.5.1.pom (5.0 kB at 96 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/3.3.1/plexus-3.3.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/3.3.1/plexus-3.3.1.pom (20 kB at 341 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.1.0/maven-model-builder-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.1.0/maven-model-builder-3.1.0.pom (2.5 kB at 49 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.1.0/maven-aether-provider-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.1.0/maven-aether-provider-3.1.0.pom (3.5 kB at 72 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/0.9.0.M2/aether-api-0.9.0.M2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/0.9.0.M2/aether-api-0.9.0.M2.pom (1.7 kB at 35 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether/0.9.0.M2/aether-0.9.0.M2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether/0.9.0.M2/aether-0.9.0.M2.pom (28 kB at 429 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/0.9.0.M2/aether-spi-0.9.0.M2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/0.9.0.M2/aether-spi-0.9.0.M2.pom (1.8 kB at 36 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-util/0.9.0.M2/aether-util-0.9.0.M2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-util/0.9.0.M2/aether-util-0.9.0.M2.pom (2.0 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/0.9.0.M2/aether-impl-0.9.0.M2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/0.9.0.M2/aether-impl-0.9.0.M2.pom (3.3 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.4.2/plexus-classworlds-2.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.4.2/plexus-classworlds-2.4.2.pom (3.5 kB at 70 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/3.0.1/plexus-3.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/3.0.1/plexus-3.0.1.pom (19 kB at 315 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.3.4/maven-shared-utils-3.3.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.3.4/maven-shared-utils-3.3.4.pom (5.8 kB at 117 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.6/commons-io-2.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.6/commons-io-2.6.pom (14 kB at 255 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/42/commons-parent-42.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/42/commons-parent-42.pom (68 kB at 781 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/18/apache-18.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/18/apache-18.pom (16 kB at 290 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-decoration-model/1.11.1/doxia-decoration-model-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-decoration-model/1.11.1/doxia-decoration-model-1.11.1.pom (3.4 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sitetools/1.11.1/doxia-sitetools-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sitetools/1.11.1/doxia-sitetools-1.11.1.pom (14 kB at 243 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.0.0/plexus-component-annotations-2.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.0.0/plexus-component-annotations-2.0.0.pom (750 B at 16 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/2.0.0/plexus-containers-2.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/2.0.0/plexus-containers-2.0.0.pom (4.8 kB at 96 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/5.1/plexus-5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/5.1/plexus-5.1.pom (23 kB at 346 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-core/1.11.1/doxia-core-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-core/1.11.1/doxia-core-1.11.1.pom (4.5 kB at 89 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.1.0/plexus-component-annotations-2.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.1.0/plexus-component-annotations-2.1.0.pom (750 B at 16 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/2.1.0/plexus-containers-2.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/2.1.0/plexus-containers-2.1.0.pom (4.8 kB at 96 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.8.1/commons-lang3-3.8.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.8.1/commons-lang3-3.8.1.pom (28 kB at 404 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/47/commons-parent-47.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/47/commons-parent-47.pom (78 kB at 760 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/19/apache-19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/19/apache-19.pom (15 kB at 272 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.pom (21 kB at 297 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/54/commons-parent-54.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/54/commons-parent-54.pom (82 kB at 853 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.9.1/junit-bom-5.9.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.9.1/junit-bom-5.9.1.pom (5.6 kB at 110 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.pom (31 kB at 458 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/52/commons-parent-52.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/52/commons-parent-52.pom (79 kB at 702 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.7.1/junit-bom-5.7.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.7.1/junit-bom-5.7.1.pom (5.1 kB at 100 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.pom (6.6 kB at 125 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-client/4.5.13/httpcomponents-client-4.5.13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-client/4.5.13/httpcomponents-client-4.5.13.pom (16 kB at 287 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-parent/11/httpcomponents-parent-11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-parent/11/httpcomponents-parent-11.pom (35 kB at 510 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/21/apache-21.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/21/apache-21.pom (17 kB at 252 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcore/4.4.13/httpcore-4.4.13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcore/4.4.13/httpcore-4.4.13.pom (5.0 kB at 86 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-core/4.4.13/httpcomponents-core-4.4.13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-core/4.4.13/httpcomponents-core-4.4.13.pom (13 kB at 239 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.pom (19 kB at 337 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/34/commons-parent-34.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/34/commons-parent-34.pom (56 kB at 518 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.pom (14 kB at 249 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcore/4.4.14/httpcore-4.4.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcore/4.4.14/httpcore-4.4.14.pom (5.0 kB at 97 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-core/4.4.14/httpcomponents-core-4.4.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-core/4.4.14/httpcomponents-core-4.4.14.pom (13 kB at 239 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-integration-tools/1.11.1/doxia-integration-tools-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-integration-tools/1.11.1/doxia-integration-tools-1.11.1.pom (6.0 kB at 99 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.0/maven-reporting-api-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.0/maven-reporting-api-3.0.pom (2.4 kB at 48 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/15/maven-shared-components-15.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/15/maven-shared-components-15.pom (9.3 kB at 187 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/16/maven-parent-16.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/16/maven-parent-16.pom (23 kB at 408 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/7/apache-7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/7/apache-7.pom (14 kB at 267 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sink-api/1.0/doxia-sink-api-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sink-api/1.0/doxia-sink-api-1.0.pom (1.4 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia/1.0/doxia-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia/1.0/doxia-1.0.pom (9.6 kB at 189 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/10/maven-parent-10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/10/maven-parent-10.pom (32 kB at 527 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/4/apache-4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/4/apache-4.pom (4.5 kB at 92 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/2.2.1/maven-artifact-2.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/2.2.1/maven-artifact-2.2.1.pom (1.6 kB at 34 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/2.2.1/maven-2.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/2.2.1/maven-2.2.1.pom (22 kB at 400 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/11/maven-parent-11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/11/maven-parent-11.pom (32 kB at 523 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/5/apache-5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/5/apache-5.pom (4.1 kB at 84 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/2.2.1/maven-model-2.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/2.2.1/maven-model-2.2.1.pom (3.2 kB at 66 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/2.2.1/maven-plugin-api-2.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/2.2.1/maven-plugin-api-2.2.1.pom (1.5 kB at 31 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-i18n/1.0-beta-10/plexus-i18n-1.0-beta-10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-i18n/1.0-beta-10/plexus-i18n-1.0-beta-10.pom (2.1 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.1.12/plexus-components-1.1.12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.1.12/plexus-components-1.1.12.pom (3.0 kB at 64 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/1.0.10/plexus-1.0.10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/1.0.10/plexus-1.0.10.pom (8.2 kB at 168 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.26/plexus-interpolation-1.26.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.26/plexus-interpolation-1.26.pom (2.7 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-site-renderer/1.11.1/doxia-site-renderer-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-site-renderer/1.11.1/doxia-site-renderer-1.11.1.pom (7.7 kB at 145 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.0/maven-artifact-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.0/maven-artifact-3.0.pom (1.9 kB at 40 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.0/maven-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.0/maven-3.0.pom (22 kB at 384 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/15/maven-parent-15.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/15/maven-parent-15.pom (24 kB at 429 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/6/apache-6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/6/apache-6.pom (13 kB at 241 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-skin-model/1.11.1/doxia-skin-model-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-skin-model/1.11.1/doxia-skin-model-1.11.1.pom (3.0 kB at 30 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml/1.11.1/doxia-module-xhtml-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml/1.11.1/doxia-module-xhtml-1.11.1.pom (2.0 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-modules/1.11.1/doxia-modules-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-modules/1.11.1/doxia-modules-1.11.1.pom (2.7 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml5/1.11.1/doxia-module-xhtml5-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml5/1.11.1/doxia-module-xhtml5-1.11.1.pom (2.0 kB at 41 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-velocity/1.2/plexus-velocity-1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-velocity/1.2/plexus-velocity-1.2.pom (2.8 kB at 59 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/4.0/plexus-components-4.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/4.0/plexus-components-4.0.pom (2.7 kB at 57 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/4.0/plexus-4.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/4.0/plexus-4.0.pom (22 kB at 364 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.1/commons-collections-3.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.1/commons-collections-3.1.pom (6.1 kB at 97 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity/1.7/velocity-1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity/1.7/velocity-1.7.pom (11 kB at 149 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.pom (13 kB at 123 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/9/commons-parent-9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/9/commons-parent-9.pom (22 kB at 264 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.pom (14 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity-tools/2.0/velocity-tools-2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity-tools/2.0/velocity-tools-2.0.pom (18 kB at 202 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.pom (357 B at 4.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.0.3/commons-logging-1.0.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.0.3/commons-logging-1.0.3.pom (866 B at 13 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-digester/commons-digester/1.8/commons-digester-1.8.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-digester/commons-digester/1.8/commons-digester-1.8.pom (7.0 kB at 93 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.1/commons-logging-1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.1/commons-logging-1.1.pom (6.2 kB at 92 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/log4j/log4j/1.2.12/log4j-1.2.12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/log4j/log4j/1.2.12/log4j-1.2.12.pom (145 B at 2.4 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/logkit/logkit/1.0.1/logkit-1.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/logkit/logkit/1.0.1/logkit-1.0.1.pom (147 B at 2.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/avalon-framework/avalon-framework/4.1.3/avalon-framework-4.1.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/avalon-framework/avalon-framework/4.1.3/avalon-framework-4.1.3.pom (167 B at 3.5 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-chain/commons-chain/1.1/commons-chain-1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-chain/commons-chain/1.1/commons-chain-1.1.pom (6.0 kB at 63 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-digester/commons-digester/1.6/commons-digester-1.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-digester/commons-digester/1.6/commons-digester-1.6.pom (974 B at 20 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-beanutils/commons-beanutils/1.6/commons-beanutils-1.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-beanutils/commons-beanutils/1.6/commons-beanutils-1.6.pom (2.3 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.0/commons-logging-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.0/commons-logging-1.0.pom (163 B at 2.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/2.0/commons-collections-2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/2.0/commons-collections-2.0.pom (171 B at 1.6 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/2.1/commons-collections-2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/2.1/commons-collections-2.1.pom (3.3 kB at 55 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/xml-apis/xml-apis/1.0.b2/xml-apis-1.0.b2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/xml-apis/xml-apis/1.0.b2/xml-apis-1.0.b2.pom (2.2 kB at 33 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2/commons-collections-3.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2/commons-collections-3.2.pom (11 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/dom4j/dom4j/1.1/dom4j-1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/dom4j/dom4j/1.1/dom4j-1.1.pom (142 B at 2.0 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/oro/oro/2.0.8/oro-2.0.8.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/oro/oro/2.0.8/oro-2.0.8.pom (140 B at 1.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity/1.6.2/velocity-1.6.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity/1.6.2/velocity-1.6.2.pom (11 kB at 138 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.pom (12 kB at 182 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/39/commons-parent-39.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/39/commons-parent-39.pom (62 kB at 620 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/16/apache-16.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/16/apache-16.pom (15 kB at 226 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.8.0/plexus-archiver-4.8.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.8.0/plexus-archiver-4.8.0.pom (6.1 kB at 111 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/14/plexus-14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/14/plexus-14.pom (28 kB at 421 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.1/plexus-io-3.4.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.1/plexus-io-3.4.1.pom (6.0 kB at 113 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/10/plexus-10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/10/plexus-10.pom (25 kB at 385 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.11.0/commons-io-2.11.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.11.0/commons-io-2.11.0.pom (20 kB at 286 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.7.2/junit-bom-5.7.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.7.2/junit-bom-5.7.2.pom (5.1 kB at 94 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.13.0/commons-io-2.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.13.0/commons-io-2.13.0.pom (20 kB at 344 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/58/commons-parent-58.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/58/commons-parent-58.pom (83 kB at 861 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.23.0/commons-compress-1.23.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.23.0/commons-compress-1.23.0.pom (22 kB at 342 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/56/commons-parent-56.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/56/commons-parent-56.pom (82 kB at 840 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.pom (2.7 kB at 54 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.36/slf4j-parent-1.7.36.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.36/slf4j-parent-1.7.36.pom (14 kB at 256 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/iq80/snappy/snappy/0.4/snappy-0.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/iq80/snappy/snappy/0.4/snappy-0.4.pom (15 kB at 255 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/tukaani/xz/1.9/xz-1.9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/tukaani/xz/1.9/xz-1.9.pom (2.0 kB at 40 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/luben/zstd-jni/1.5.5-5/zstd-jni-1.5.5-5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/luben/zstd-jni/1.5.5-5/zstd-jni-1.5.5-5.pom (1.9 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.1/plexus-utils-3.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.1/plexus-utils-3.5.1.pom (8.8 kB at 172 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-analyzer/1.13.2/maven-dependency-analyzer-1.13.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-analyzer/1.13.2/maven-dependency-analyzer-1.13.2.pom (6.4 kB at 113 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/39/maven-shared-components-39.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/39/maven-shared-components-39.pom (3.2 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.2.5/maven-core-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.2.5/maven-core-3.2.5.pom (8.1 kB at 158 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.2.5/maven-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.2.5/maven-3.2.5.pom (22 kB at 392 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/25/maven-parent-25.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/25/maven-parent-25.pom (37 kB at 585 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/apache/15/apache-15.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/apache/15/apache-15.pom (15 kB at 258 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.2.5/maven-model-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.2.5/maven-model-3.2.5.pom (4.2 kB at 85 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.2.5/maven-settings-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.2.5/maven-settings-3.2.5.pom (2.2 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.2.5/maven-settings-builder-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.2.5/maven-settings-builder-3.2.5.pom (2.6 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.21/plexus-interpolation-1.21.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.21/plexus-interpolation-1.21.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.3.1/plexus-components-1.3.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.3.1/plexus-components-1.3.1.pom (3.1 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.2.5/maven-repository-metadata-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.2.5/maven-repository-metadata-3.2.5.pom (2.2 kB at 41 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.2.5/maven-artifact-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.2.5/maven-artifact-3.2.5.pom (2.3 kB at 47 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.2.5/maven-plugin-api-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.2.5/maven-plugin-api-3.2.5.pom (3.0 kB at 61 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.2.5/maven-model-builder-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.2.5/maven-model-builder-3.2.5.pom (3.0 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.2.5/maven-aether-provider-3.2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.2.5/maven-aether-provider-3.2.5.pom (4.2 kB at 77 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/1.0.0.v20140518/aether-api-1.0.0.v20140518.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/1.0.0.v20140518/aether-api-1.0.0.v20140518.pom (1.9 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether/1.0.0.v20140518/aether-1.0.0.v20140518.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether/1.0.0.v20140518/aether-1.0.0.v20140518.pom (30 kB at 413 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/1.0.0.v20140518/aether-spi-1.0.0.v20140518.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/1.0.0.v20140518/aether-spi-1.0.0.v20140518.pom (2.1 kB at 37 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-util/1.0.0.v20140518/aether-util-1.0.0.v20140518.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-util/1.0.0.v20140518/aether-util-1.0.0.v20140518.pom (2.2 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/1.0.0.v20140518/aether-impl-1.0.0.v20140518.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/1.0.0.v20140518/aether-impl-1.0.0.v20140518.pom (3.5 kB at 71 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-guice/3.2.3/sisu-guice-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-guice/3.2.3/sisu-guice-3.2.3.pom (11 kB at 206 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/inject/guice-parent/3.2.3/guice-parent-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/inject/guice-parent/3.2.3/guice-parent-3.2.3.pom (13 kB at 250 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/38/forge-parent-38.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/38/forge-parent-38.pom (19 kB at 323 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/aopalliance/aopalliance/1.0/aopalliance-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/aopalliance/aopalliance/1.0/aopalliance-1.0.pom (363 B at 6.7 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/guava/guava/16.0.1/guava-16.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/guava/guava/16.0.1/guava-16.0.1.pom (6.1 kB at 113 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/guava/guava-parent/16.0.1/guava-parent-16.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/guava/guava-parent/16.0.1/guava-parent-16.0.1.pom (7.3 kB at 108 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.2/plexus-classworlds-2.5.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.2/plexus-classworlds-2.5.2.pom (7.3 kB at 140 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.5/asm-9.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.5/asm-9.5.pom (2.4 kB at 40 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/ow2/1.5.1/ow2-1.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/ow2/1.5.1/ow2-1.5.1.pom (11 kB at 202 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-tree/3.2.1/maven-dependency-tree-3.2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-tree/3.2.1/maven-dependency-tree-3.2.1.pom (6.2 kB at 120 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/37/maven-shared-components-37.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/37/maven-shared-components-37.pom (4.9 kB at 96 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.3.2/maven-common-artifact-filters-3.3.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.3.2/maven-common-artifact-filters-3.3.2.pom (5.3 kB at 105 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-artifact-transfer/0.13.1/maven-artifact-transfer-0.13.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-artifact-transfer/0.13.1/maven-artifact-transfer-0.13.1.pom (11 kB at 208 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.0/maven-core-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.0/maven-core-3.0.pom (6.6 kB at 127 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.0/maven-model-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.0/maven-model-3.0.pom (3.9 kB at 79 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.0/maven-settings-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.0/maven-settings-3.0.pom (1.9 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.0/maven-settings-builder-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.0/maven-settings-builder-3.0.pom (2.2 kB at 40 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.14/plexus-interpolation-1.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.14/plexus-interpolation-1.14.pom (910 B at 19 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.1.18/plexus-components-1.1.18.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/1.1.18/plexus-components-1.1.18.pom (5.4 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.0/maven-repository-metadata-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.0/maven-repository-metadata-3.0.pom (1.9 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.0/maven-plugin-api-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.0/maven-plugin-api-3.0.pom (2.3 kB at 48 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-inject-plexus/1.4.2/sisu-inject-plexus-1.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-inject-plexus/1.4.2/sisu-inject-plexus-1.4.2.pom (5.4 kB at 110 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/inject/guice-plexus/1.4.2/guice-plexus-1.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/inject/guice-plexus/1.4.2/guice-plexus-1.4.2.pom (3.1 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/inject/guice-bean/1.4.2/guice-bean-1.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/inject/guice-bean/1.4.2/guice-bean-1.4.2.pom (2.6 kB at 55 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-inject/1.4.2/sisu-inject-1.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-inject/1.4.2/sisu-inject-1.4.2.pom (1.2 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-parent/1.4.2/sisu-parent-1.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-parent/1.4.2/sisu-parent-1.4.2.pom (7.8 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/6/forge-parent-6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/6/forge-parent-6.pom (11 kB at 192 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.4/plexus-component-annotations-1.5.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.4/plexus-component-annotations-1.5.4.pom (815 B at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.5.4/plexus-containers-1.5.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.5.4/plexus-containers-1.5.4.pom (4.2 kB at 80 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.5/plexus-2.0.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.5/plexus-2.0.5.pom (17 kB at 284 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.2.3/plexus-classworlds-2.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.2.3/plexus-classworlds-2.2.3.pom (4.0 kB at 78 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.6/plexus-2.0.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.6/plexus-2.0.6.pom (17 kB at 294 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-inject-bean/1.4.2/sisu-inject-bean-1.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-inject-bean/1.4.2/sisu-inject-bean-1.4.2.pom (5.5 kB at 99 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-guice/2.1.7/sisu-guice-2.1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-guice/2.1.7/sisu-guice-2.1.7.pom (11 kB at 170 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.0/maven-model-builder-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.0/maven-model-builder-3.0.pom (2.2 kB at 48 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.0/maven-aether-provider-3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.0/maven-aether-provider-3.0.pom (2.5 kB at 44 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-api/1.7/aether-api-1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-api/1.7/aether-api-1.7.pom (1.7 kB at 34 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-parent/1.7/aether-parent-1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-parent/1.7/aether-parent-1.7.pom (7.7 kB at 149 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-util/1.7/aether-util-1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-util/1.7/aether-util-1.7.pom (2.1 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-impl/1.7/aether-impl-1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-impl/1.7/aether-impl-1.7.pom (3.7 kB at 77 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-spi/1.7/aether-spi-1.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/aether/aether-spi/1.7/aether-spi-1.7.pom (1.7 kB at 36 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.1.0/maven-common-artifact-filters-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.1.0/maven-common-artifact-filters-3.1.0.pom (5.3 kB at 106 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/33/maven-shared-components-33.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/33/maven-shared-components-33.pom (5.1 kB at 98 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/33/maven-parent-33.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/33/maven-parent-33.pom (44 kB at 640 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.1.0/maven-shared-utils-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.1.0/maven-shared-utils-3.1.0.pom (5.0 kB at 98 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/30/maven-shared-components-30.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/30/maven-shared-components-30.pom (4.6 kB at 98 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/30/maven-parent-30.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-parent/30/maven-parent-30.pom (41 kB at 617 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.5/commons-io-2.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.5/commons-io-2.5.pom (13 kB at 251 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.5/slf4j-api-1.7.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.5/slf4j-api-1.7.5.pom (2.7 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.5/slf4j-parent-1.7.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.5/slf4j-parent-1.7.5.pom (12 kB at 211 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.4.2/maven-shared-utils-3.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.4.2/maven-shared-utils-3.4.2.pom (5.9 kB at 116 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.pom (24 kB at 403 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/48/commons-parent-48.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/48/commons-parent-48.pom (72 kB at 868 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-build-api/0.0.7/plexus-build-api-0.0.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-build-api/0.0.7/plexus-build-api-0.0.7.pom (3.2 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/spice/spice-parent/15/spice-parent-15.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/spice/spice-parent/15/spice-parent-15.pom (8.4 kB at 167 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/5/forge-parent-5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/forge/forge-parent/5/forge-parent-5.pom (8.4 kB at 167 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sink-api/1.11.1/doxia-sink-api-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-sink-api/1.11.1/doxia-sink-api-1.11.1.jar (12 kB at 219 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-logging-api/1.11.1/doxia-logging-api-1.11.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.1.1/maven-reporting-api-3.1.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-impl/3.2.0/maven-reporting-impl-3.2.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.1.0/maven-core-3.1.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.1.0/maven-settings-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.1.1/maven-reporting-api-3.1.1.jar (11 kB at 189 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.1.0/maven-settings-builder-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.1.0/maven-settings-builder-3.1.0.jar (41 kB at 334 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-logging-api/1.11.1/doxia-logging-api-1.11.1.jar (12 kB at 69 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.1.0/maven-model-builder-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-impl/3.2.0/maven-reporting-impl-3.2.0.jar (20 kB at 99 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.1.0/maven-aether-provider-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.1.0/maven-settings-3.1.0.jar (47 kB at 197 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/0.9.0.M2/aether-spi-0.9.0.M2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar (30 kB at 110 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/0.9.0.M2/aether-impl-0.9.0.M2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/0.9.0.M2/aether-spi-0.9.0.M2.jar (18 kB at 55 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/0.9.0.M2/aether-api-0.9.0.M2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.1.0/maven-aether-provider-3.1.0.jar (60 kB at 184 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.0.M1/org.eclipse.sisu.plexus-0.3.0.M1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.1.0/maven-model-builder-3.1.0.jar (159 kB at 373 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.0/cdi-api-1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/0.9.0.M2/aether-impl-0.9.0.M2.jar (145 kB at 325 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/annotation/jsr250-api/1.0/jsr250-api-1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.0.M1/org.eclipse.sisu.plexus-0.3.0.M1.jar (201 kB at 404 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.0.M1/org.eclipse.sisu.inject-0.3.0.M1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.0/cdi-api-1.0.jar (45 kB at 87 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.16/plexus-interpolation-1.16.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/annotation/jsr250-api/1.0/jsr250-api-1.0.jar (5.8 kB at 11 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/0.9.0.M2/aether-api-0.9.0.M2.jar (134 kB at 256 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.4.2/plexus-classworlds-2.4.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-sec-dispatcher/1.3/plexus-sec-dispatcher-1.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-sec-dispatcher/1.3/plexus-sec-dispatcher-1.3.jar (29 kB at 47 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.4.2/plexus-classworlds-2.4.2.jar (47 kB at 75 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.1.0/maven-artifact-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.16/plexus-interpolation-1.16.jar (61 kB at 97 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.0/maven-plugin-api-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.jar (13 kB at 19 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-decoration-model/1.11.1/doxia-decoration-model-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.1.0/maven-core-3.1.0.jar (563 kB at 799 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-core/1.11.1/doxia-core-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.1.0/maven-artifact-3.1.0.jar (52 kB at 72 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.0.M1/org.eclipse.sisu.inject-0.3.0.M1.jar (340 kB at 468 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.8.1/commons-lang3-3.8.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.0/maven-plugin-api-3.1.0.jar (50 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-decoration-model/1.11.1/doxia-decoration-model-1.11.1.jar (60 kB at 76 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar (62 kB at 69 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-core/1.11.1/doxia-core-1.11.1.jar (218 kB at 232 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcore/4.4.14/httpcore-4.4.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar (238 kB at 230 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-integration-tools/1.11.1/doxia-integration-tools-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-integration-tools/1.11.1/doxia-integration-tools-1.11.1.jar (47 kB at 41 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-site-renderer/1.11.1/doxia-site-renderer-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.jar (780 kB at 658 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-skin-model/1.11.1/doxia-skin-model-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-site-renderer/1.11.1/doxia-site-renderer-1.11.1.jar (65 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml/1.11.1/doxia-module-xhtml-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-skin-model/1.11.1/doxia-skin-model-1.11.1.jar (16 kB at 11 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml5/1.11.1/doxia-module-xhtml5-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcore/4.4.14/httpcore-4.4.14.jar (328 kB at 222 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-velocity/1.2/plexus-velocity-1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.8.1/commons-lang3-3.8.1.jar (502 kB at 334 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar (335 kB at 223 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity/1.7/velocity-1.7.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml/1.11.1/doxia-module-xhtml-1.11.1.jar (17 kB at 12 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity-tools/2.0/velocity-tools-2.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xhtml5/1.11.1/doxia-module-xhtml5-1.11.1.jar (18 kB at 12 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-velocity/1.2/plexus-velocity-1.2.jar (8.1 kB at 5.2 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-digester/commons-digester/1.8/commons-digester-1.8.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.jar (189 kB at 113 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-chain/commons-chain/1.1/commons-chain-1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-digester/commons-digester/1.8/commons-digester-1.8.jar (144 kB at 82 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/dom4j/dom4j/1.1/dom4j-1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-chain/commons-chain/1.1/commons-chain-1.1.jar (90 kB at 50 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/oro/oro/2.0.8/oro-2.0.8.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.jar (262 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity-tools/2.0/velocity-tools-2.0.jar (347 kB at 181 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.8.0/plexus-archiver-4.8.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/oro/oro/2.0.8/oro-2.0.8.jar (65 kB at 34 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/inject/javax.inject/1/javax.inject-1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/velocity/velocity/1.7/velocity-1.7.jar (450 kB at 228 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.13.0/commons-io-2.13.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/inject/javax.inject/1/javax.inject-1.jar (2.5 kB at 1.3 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.23.0/commons-compress-1.23.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/dom4j/dom4j/1.1/dom4j-1.1.jar (457 kB at 217 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.8.0/plexus-archiver-4.8.0.jar (224 kB at 104 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/iq80/snappy/snappy/0.4/snappy-0.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar (41 kB at 19 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/tukaani/xz/1.9/xz-1.9.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/iq80/snappy/snappy/0.4/snappy-0.4.jar (58 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/luben/zstd-jni/1.5.5-5/zstd-jni-1.5.5-5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/tukaani/xz/1.9/xz-1.9.jar (116 kB at 49 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.1/plexus-utils-3.5.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.13.0/commons-io-2.13.0.jar (484 kB at 187 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.1/plexus-io-3.4.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.jar (588 kB at 226 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-i18n/1.0-beta-10/plexus-i18n-1.0-beta-10.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.23.0/commons-compress-1.23.0.jar (1.1 MB at 405 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-analyzer/1.13.2/maven-dependency-analyzer-1.13.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-i18n/1.0-beta-10/plexus-i18n-1.0-beta-10.jar (12 kB at 4.5 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.1/plexus-utils-3.5.1.jar (269 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.2.5/maven-model-3.2.5.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.5/asm-9.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-analyzer/1.13.2/maven-dependency-analyzer-1.13.2.jar (39 kB at 14 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-tree/3.2.1/maven-dependency-tree-3.2.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.1/plexus-io-3.4.1.jar (79 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-util/1.0.0.v20140518/aether-util-1.0.0.v20140518.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-dependency-tree/3.2.1/maven-dependency-tree-3.2.1.jar (43 kB at 15 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.3.2/maven-common-artifact-filters-3.3.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.5/asm-9.5.jar (122 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-artifact-transfer/0.13.1/maven-artifact-transfer-0.13.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.3.2/maven-common-artifact-filters-3.3.2.jar (58 kB at 20 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.0.0/plexus-component-annotations-2.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.2.5/maven-model-3.2.5.jar (161 kB at 56 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.4.2/maven-shared-utils-3.4.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-util/1.0.0.v20140518/aether-util-1.0.0.v20140518.jar (146 kB at 50 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-artifact-transfer/0.13.1/maven-artifact-transfer-0.13.1.jar (159 kB at 54 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-build-api/0.0.7/plexus-build-api-0.0.7.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.0.0/plexus-component-annotations-2.0.0.jar (4.2 kB at 1.4 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/plexus/plexus-build-api/0.0.7/plexus-build-api-0.0.7.jar (8.5 kB at 2.8 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.4.2/maven-shared-utils-3.4.2.jar (151 kB at 49 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.jar (752 kB at 221 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/luben/zstd-jni/1.5.5-5/zstd-jni-1.5.5-5.jar (5.9 MB at 1.4 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/maven-surefire-common/3.1.2/maven-surefire-common-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/maven-surefire-common/3.1.2/maven-surefire-common-3.1.2.pom (6.1 kB at 111 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-api/3.1.2/surefire-api-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-api/3.1.2/surefire-api-3.1.2.pom (3.5 kB at 71 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-logger-api/3.1.2/surefire-logger-api-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-logger-api/3.1.2/surefire-logger-api-3.1.2.pom (3.3 kB at 60 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-shared-utils/3.1.2/surefire-shared-utils-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-shared-utils/3.1.2/surefire-shared-utils-3.1.2.pom (4.1 kB at 83 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-api/3.1.2/surefire-extensions-api-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-api/3.1.2/surefire-extensions-api-3.1.2.pom (3.3 kB at 60 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-booter/3.1.2/surefire-booter-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-booter/3.1.2/surefire-booter-3.1.2.pom (4.5 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-spi/3.1.2/surefire-extensions-spi-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-spi/3.1.2/surefire-extensions-spi-3.1.2.pom (1.8 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.1.1/maven-common-artifact-filters-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.1.1/maven-common-artifact-filters-3.1.1.pom (5.8 kB at 104 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.0/plexus-utils-3.5.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.0/plexus-utils-3.5.0.pom (8.0 kB at 157 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.5/org.eclipse.sisu.plexus-0.3.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.5/org.eclipse.sisu.plexus-0.3.5.pom (4.3 kB at 86 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-plexus/0.3.5/sisu-plexus-0.3.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-plexus/0.3.5/sisu-plexus-0.3.5.pom (14 kB at 218 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.pom (13 kB at 258 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/jvnet-parent/3/jvnet-parent-3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/jvnet-parent/3/jvnet-parent-3.pom (4.8 kB at 83 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.2/cdi-api-1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.2/cdi-api-1.2.pom (6.3 kB at 112 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-parent/26/weld-parent-26.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/weld/weld-parent/26/weld-parent-26.pom (32 kB at 437 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.5/org.eclipse.sisu.inject-0.3.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.5/org.eclipse.sisu.inject-0.3.5.pom (2.6 kB at 54 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-inject/0.3.5/sisu-inject-0.3.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/sisu-inject/0.3.5/sisu-inject-0.3.5.pom (14 kB at 257 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.12.0/commons-io-2.12.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.12.0/commons-io-2.12.0.pom (20 kB at 323 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/57/commons-parent-57.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/57/commons-parent-57.pom (83 kB at 711 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-java/1.1.2/plexus-java-1.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-java/1.1.2/plexus-java-1.1.2.pom (5.0 kB at 108 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-languages/1.1.2/plexus-languages-1.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-languages/1.1.2/plexus-languages-1.1.2.pom (4.1 kB at 86 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.4/asm-9.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.4/asm-9.4.pom (2.4 kB at 52 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/thoughtworks/qdox/qdox/2.0.3/qdox-2.0.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/thoughtworks/qdox/qdox/2.0.3/qdox-2.0.3.pom (17 kB at 292 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/maven-surefire-common/3.1.2/maven-surefire-common-3.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/maven-surefire-common/3.1.2/maven-surefire-common-3.1.2.jar (306 kB at 1.1 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-api/3.1.2/surefire-api-3.1.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-logger-api/3.1.2/surefire-logger-api-3.1.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-api/3.1.2/surefire-extensions-api-3.1.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-booter/3.1.2/surefire-booter-3.1.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-spi/3.1.2/surefire-extensions-spi-3.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-spi/3.1.2/surefire-extensions-spi-3.1.2.jar (8.2 kB at 91 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/1.0.0.v20140518/aether-api-1.0.0.v20140518.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-logger-api/3.1.2/surefire-logger-api-3.1.2.jar (14 kB at 108 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.1.1/maven-common-artifact-filters-3.1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-extensions-api/3.1.2/surefire-extensions-api-3.1.2.jar (26 kB at 149 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.2.5/maven-artifact-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-booter/3.1.2/surefire-booter-3.1.2.jar (118 kB at 454 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.0/plexus-utils-3.5.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-api/3.1.2/surefire-api-3.1.2.jar (171 kB at 478 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.2.5/maven-core-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-common-artifact-filters/3.1.1/maven-common-artifact-filters-3.1.1.jar (61 kB at 121 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.2.5/maven-settings-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.2.5/maven-artifact-3.2.5.jar (55 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.2.5/maven-settings-builder-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-api/1.0.0.v20140518/aether-api-1.0.0.v20140518.jar (136 kB at 207 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.2.5/maven-repository-metadata-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.2.5/maven-settings-3.2.5.jar (43 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.2.5/maven-model-builder-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.2.5/maven-settings-builder-3.2.5.jar (44 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.2.5/maven-aether-provider-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.5.0/plexus-utils-3.5.0.jar (267 kB at 224 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/1.0.0.v20140518/aether-spi-1.0.0.v20140518.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.2.5/maven-repository-metadata-3.2.5.jar (26 kB at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/1.0.0.v20140518/aether-impl-1.0.0.v20140518.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.2.5/maven-core-3.2.5.jar (608 kB at 459 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.5/org.eclipse.sisu.plexus-0.3.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-spi/1.0.0.v20140518/aether-spi-1.0.0.v20140518.jar (31 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.2.5/maven-aether-provider-3.2.5.jar (66 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.2/cdi-api-1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.jar (26 kB at 15 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/aether/aether-impl/1.0.0.v20140518/aether-impl-1.0.0.v20140518.jar (172 kB at 98 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.5/org.eclipse.sisu.inject-0.3.5.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-guice/3.2.3/sisu-guice-3.2.3-no_aop.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.5/org.eclipse.sisu.plexus-0.3.5.jar (205 kB at 112 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/aopalliance/aopalliance/1.0/aopalliance-1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.2.5/maven-model-builder-3.2.5.jar (170 kB at 91 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/guava/guava/16.0.1/guava-16.0.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/enterprise/cdi-api/1.2/cdi-api-1.2.jar (71 kB at 35 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.21/plexus-interpolation-1.21.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/aopalliance/aopalliance/1.0/aopalliance-1.0.jar (4.5 kB at 2.2 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.2/plexus-classworlds-2.5.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.21/plexus-interpolation-1.21.jar (62 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.5/plexus-component-annotations-1.5.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.2/plexus-classworlds-2.5.2.jar (53 kB at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.2.5/maven-plugin-api-3.2.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.5/org.eclipse.sisu.inject-0.3.5.jar (379 kB at 152 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.12.0/commons-io-2.12.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/sonatype/sisu/sisu-guice/3.2.3/sisu-guice-3.2.3-no_aop.jar (398 kB at 157 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-java/1.1.2/plexus-java-1.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.5/plexus-component-annotations-1.5.5.jar (4.2 kB at 1.6 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.4/asm-9.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.2.5/maven-plugin-api-3.2.5.jar (46 kB at 18 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/thoughtworks/qdox/qdox/2.0.3/qdox-2.0.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-java/1.1.2/plexus-java-1.1.2.jar (55 kB at 20 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-shared-utils/3.1.2/surefire-shared-utils-3.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.4/asm-9.4.jar (122 kB at 44 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.12.0/commons-io-2.12.0.jar (474 kB at 142 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/thoughtworks/qdox/qdox/2.0.3/qdox-2.0.3.jar (334 kB at 89 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/surefire/surefire-shared-utils/3.1.2/surefire-shared-utils-3.1.2.jar (2.3 MB at 449 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/guava/guava/16.0.1/guava-16.0.1.jar (2.2 MB at 406 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-filtering/3.3.1/maven-filtering-3.3.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-filtering/3.3.1/maven-filtering-3.3.1.pom (6.0 kB at 126 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.26/plexus-interpolation-1.26.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.26/plexus-interpolation-1.26.jar (85 kB at 1.2 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-filtering/3.3.1/maven-filtering-3.3.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.11.0/commons-io-2.11.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-filtering/3.3.1/maven-filtering-3.3.1.jar (55 kB at 809 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.11.0/commons-io-2.11.0.jar (327 kB at 1.6 MB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar (587 kB at 1.3 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-incremental/1.1/maven-shared-incremental-1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-incremental/1.1/maven-shared-incremental-1.1.pom (4.7 kB at 101 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/19/maven-shared-components-19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/19/maven-shared-components-19.pom (6.4 kB at 138 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-api/2.13.0/plexus-compiler-api-2.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-api/2.13.0/plexus-compiler-api-2.13.0.pom (1.1 kB at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler/2.13.0/plexus-compiler-2.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler/2.13.0/plexus-compiler-2.13.0.pom (8.4 kB at 150 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/10.0/plexus-components-10.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-components/10.0/plexus-components-10.0.pom (2.7 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-manager/2.13.0/plexus-compiler-manager-2.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-manager/2.13.0/plexus-compiler-manager-2.13.0.pom (1.1 kB at 23 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.1.1/plexus-component-annotations-2.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.1.1/plexus-component-annotations-2.1.1.pom (770 B at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/2.1.1/plexus-containers-2.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/2.1.1/plexus-containers-2.1.1.pom (6.0 kB at 126 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/6.5/plexus-6.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/6.5/plexus-6.5.pom (26 kB at 476 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-javac/2.13.0/plexus-compiler-javac-2.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-javac/2.13.0/plexus-compiler-javac-2.13.0.pom (1.2 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compilers/2.13.0/plexus-compilers-2.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compilers/2.13.0/plexus-compilers-2.13.0.pom (1.3 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.3.4/maven-shared-utils-3.3.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.3.4/maven-shared-utils-3.3.4.jar (153 kB at 1.3 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.6/commons-io-2.6.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-incremental/1.1/maven-shared-incremental-1.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-api/2.13.0/plexus-compiler-api-2.13.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-manager/2.13.0/plexus-compiler-manager-2.13.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-javac/2.13.0/plexus-compiler-javac-2.13.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-manager/2.13.0/plexus-compiler-manager-2.13.0.jar (4.7 kB at 88 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-javac/2.13.0/plexus-compiler-javac-2.13.0.jar (23 kB at 380 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-incremental/1.1/maven-shared-incremental-1.1.jar (14 kB at 215 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-compiler-api/2.13.0/plexus-compiler-api-2.13.0.jar (27 kB at 429 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/commons-io/commons-io/2.6/commons-io-2.6.jar (215 kB at 1.4 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-exec/1.6.0/maven-reporting-exec-1.6.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-exec/1.6.0/maven-reporting-exec-1.6.0.pom (14 kB at 272 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.1.0/maven-reporting-api-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-api/3.1.0/maven-reporting-api-3.1.0.pom (3.8 kB at 78 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.3.0/plexus-utils-3.3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.3.0/plexus-utils-3.3.0.pom (5.2 kB at 102 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.5.2/maven-archiver-3.5.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.5.2/maven-archiver-3.5.2.pom (5.5 kB at 99 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.1.1/maven-artifact-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-artifact/3.1.1/maven-artifact-3.1.1.pom (2.0 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.1.1/maven-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven/3.1.1/maven-3.1.1.pom (22 kB at 374 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.1.1/maven-model-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model/3.1.1/maven-model-3.1.1.pom (4.1 kB at 90 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.1.1/maven-core-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-core/3.1.1/maven-core-3.1.1.pom (7.3 kB at 151 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.1.1/maven-settings-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings/3.1.1/maven-settings-3.1.1.pom (2.2 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.1.1/maven-settings-builder-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-settings-builder/3.1.1/maven-settings-builder-3.1.1.pom (2.6 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.19/plexus-interpolation-1.19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-interpolation/1.19/plexus-interpolation-1.19.pom (1.0 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.1.1/maven-repository-metadata-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-repository-metadata/3.1.1/maven-repository-metadata-3.1.1.pom (2.2 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.1/maven-plugin-api-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.1/maven-plugin-api-3.1.1.pom (3.4 kB at 69 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.1.1/maven-model-builder-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-model-builder/3.1.1/maven-model-builder-3.1.1.pom (2.8 kB at 56 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.1.1/maven-aether-provider-3.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-aether-provider/3.1.1/maven-aether-provider-3.1.1.pom (4.1 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.3.3/maven-shared-utils-3.3.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-utils/3.3.3/maven-shared-utils-3.3.3.pom (5.8 kB at 115 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.pom (18 kB at 228 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.2.7/plexus-archiver-4.2.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.2.7/plexus-archiver-4.2.7.pom (4.9 kB at 102 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/8/plexus-8.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/8/plexus-8.pom (25 kB at 344 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.2.0/plexus-io-3.2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.2.0/plexus-io-3.2.0.pom (4.5 kB at 89 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.pom (20 kB at 328 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.4.2/plexus-utils-3.4.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.4.2/plexus-utils-3.4.2.pom (8.2 kB at 144 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/2.1.0/plexus-container-default-2.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/2.1.0/plexus-container-default-2.1.0.pom (3.0 kB at 60 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.6.0/plexus-classworlds-2.6.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/2.6.0/plexus-classworlds-2.6.0.pom (7.9 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/xbean/xbean-reflect/3.7/xbean-reflect-3.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/xbean/xbean-reflect/3.7/xbean-reflect-3.7.pom (5.1 kB at 102 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/xbean/xbean/3.7/xbean-3.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/xbean/xbean/3.7/xbean-3.7.pom (15 kB at 234 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/geronimo/genesis/genesis-java5-flava/2.0/genesis-java5-flava-2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/geronimo/genesis/genesis-java5-flava/2.0/genesis-java5-flava-2.0.pom (5.5 kB at 105 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/geronimo/genesis/genesis-default-flava/2.0/genesis-default-flava-2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/geronimo/genesis/genesis-default-flava/2.0/genesis-default-flava-2.0.pom (18 kB at 287 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/geronimo/genesis/genesis/2.0/genesis-2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/geronimo/genesis/genesis/2.0/genesis-2.0.pom (18 kB at 275 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/collections/google-collections/1.0/google-collections-1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/collections/google-collections/1.0/google-collections-1.0.pom (2.5 kB at 52 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/google/1/google-1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/google/1/google-1.pom (1.6 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.3/commons-text-1.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.3/commons-text-1.3.pom (14 kB at 259 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/45/commons-parent-45.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-parent/45/commons-parent-45.pom (73 kB at 903 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.7/commons-lang3-3.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.7/commons-lang3-3.7.pom (28 kB at 437 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-apt/1.11.1/doxia-module-apt-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-apt/1.11.1/doxia-module-apt-1.11.1.pom (2.1 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xdoc/1.11.1/doxia-module-xdoc-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xdoc/1.11.1/doxia-module-xdoc-1.11.1.pom (4.5 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-fml/1.11.1/doxia-module-fml-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-fml/1.11.1/doxia-module-fml-1.11.1.pom (4.4 kB at 89 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-markdown/1.11.1/doxia-module-markdown-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-markdown/1.11.1/doxia-module-markdown-1.11.1.pom (5.4 kB at 112 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-all/0.42.14/flexmark-all-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-all/0.42.14/flexmark-all-0.42.14.pom (9.0 kB at 132 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-java/0.42.14/flexmark-java-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-java/0.42.14/flexmark-java-0.42.14.pom (20 kB at 317 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark/0.42.14/flexmark-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark/0.42.14/flexmark-0.42.14.pom (2.5 kB at 52 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-util/0.42.14/flexmark-util-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-util/0.42.14/flexmark-util-0.42.14.pom (792 B at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-abbreviation/0.42.14/flexmark-ext-abbreviation-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-abbreviation/0.42.14/flexmark-ext-abbreviation-0.42.14.pom (2.5 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-autolink/0.42.14/flexmark-ext-autolink-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-autolink/0.42.14/flexmark-ext-autolink-0.42.14.pom (1.8 kB at 37 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/nibor/autolink/autolink/0.6.0/autolink-0.6.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/nibor/autolink/autolink/0.6.0/autolink-0.6.0.pom (9.2 kB at 155 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-formatter/0.42.14/flexmark-formatter-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-formatter/0.42.14/flexmark-formatter-0.42.14.pom (1.1 kB at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-admonition/0.42.14/flexmark-ext-admonition-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-admonition/0.42.14/flexmark-ext-admonition-0.42.14.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-anchorlink/0.42.14/flexmark-ext-anchorlink-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-anchorlink/0.42.14/flexmark-ext-anchorlink-0.42.14.pom (1.6 kB at 31 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-aside/0.42.14/flexmark-ext-aside-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-aside/0.42.14/flexmark-ext-aside-0.42.14.pom (1.5 kB at 31 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-jira-converter/0.42.14/flexmark-jira-converter-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-jira-converter/0.42.14/flexmark-jira-converter-0.42.14.pom (2.1 kB at 44 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-strikethrough/0.42.14/flexmark-ext-gfm-strikethrough-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-strikethrough/0.42.14/flexmark-ext-gfm-strikethrough-0.42.14.pom (1.3 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-tables/0.42.14/flexmark-ext-tables-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-tables/0.42.14/flexmark-ext-tables-0.42.14.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-wikilink/0.42.14/flexmark-ext-wikilink-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-wikilink/0.42.14/flexmark-ext-wikilink-0.42.14.pom (1.5 kB at 30 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-ins/0.42.14/flexmark-ext-ins-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-ins/0.42.14/flexmark-ext-ins-0.42.14.pom (1.3 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-superscript/0.42.14/flexmark-ext-superscript-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-superscript/0.42.14/flexmark-ext-superscript-0.42.14.pom (1.3 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-attributes/0.42.14/flexmark-ext-attributes-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-attributes/0.42.14/flexmark-ext-attributes-0.42.14.pom (2.6 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-definition/0.42.14/flexmark-ext-definition-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-definition/0.42.14/flexmark-ext-definition-0.42.14.pom (1.3 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-emoji/0.42.14/flexmark-ext-emoji-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-emoji/0.42.14/flexmark-ext-emoji-0.42.14.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-enumerated-reference/0.42.14/flexmark-ext-enumerated-reference-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-enumerated-reference/0.42.14/flexmark-ext-enumerated-reference-0.42.14.pom (1.7 kB at 33 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-escaped-character/0.42.14/flexmark-ext-escaped-character-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-escaped-character/0.42.14/flexmark-ext-escaped-character-0.42.14.pom (1.3 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-footnotes/0.42.14/flexmark-ext-footnotes-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-footnotes/0.42.14/flexmark-ext-footnotes-0.42.14.pom (1.3 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-issues/0.42.14/flexmark-ext-gfm-issues-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-issues/0.42.14/flexmark-ext-gfm-issues-0.42.14.pom (1.3 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tables/0.42.14/flexmark-ext-gfm-tables-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tables/0.42.14/flexmark-ext-gfm-tables-0.42.14.pom (1.3 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tasklist/0.42.14/flexmark-ext-gfm-tasklist-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tasklist/0.42.14/flexmark-ext-gfm-tasklist-0.42.14.pom (1.4 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-users/0.42.14/flexmark-ext-gfm-users-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-users/0.42.14/flexmark-ext-gfm-users-0.42.14.pom (1.3 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gitlab/0.42.14/flexmark-ext-gitlab-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gitlab/0.42.14/flexmark-ext-gitlab-0.42.14.pom (1.3 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-front-matter/0.42.14/flexmark-ext-jekyll-front-matter-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-front-matter/0.42.14/flexmark-ext-jekyll-front-matter-0.42.14.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-yaml-front-matter/0.42.14/flexmark-ext-yaml-front-matter-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-yaml-front-matter/0.42.14/flexmark-ext-yaml-front-matter-0.42.14.pom (1.3 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-tag/0.42.14/flexmark-ext-jekyll-tag-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-tag/0.42.14/flexmark-ext-jekyll-tag-0.42.14.pom (1.3 kB at 27 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-media-tags/0.42.14/flexmark-ext-media-tags-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-media-tags/0.42.14/flexmark-ext-media-tags-0.42.14.pom (1.0 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-macros/0.42.14/flexmark-ext-macros-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-macros/0.42.14/flexmark-ext-macros-0.42.14.pom (1.6 kB at 33 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-xwiki-macros/0.42.14/flexmark-ext-xwiki-macros-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-xwiki-macros/0.42.14/flexmark-ext-xwiki-macros-0.42.14.pom (1.3 kB at 24 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-toc/0.42.14/flexmark-ext-toc-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-toc/0.42.14/flexmark-ext-toc-0.42.14.pom (1.5 kB at 31 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-typographic/0.42.14/flexmark-ext-typographic-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-typographic/0.42.14/flexmark-ext-typographic-0.42.14.pom (1.3 kB at 28 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-youtube-embedded/0.42.14/flexmark-ext-youtube-embedded-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-youtube-embedded/0.42.14/flexmark-ext-youtube-embedded-0.42.14.pom (883 B at 18 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-html-parser/0.42.14/flexmark-html-parser-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-html-parser/0.42.14/flexmark-html-parser-0.42.14.pom (1.5 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jsoup/jsoup/1.10.2/jsoup-1.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jsoup/jsoup/1.10.2/jsoup-1.10.2.pom (7.3 kB at 140 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-profile-pegdown/0.42.14/flexmark-profile-pegdown-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-profile-pegdown/0.42.14/flexmark-profile-pegdown-0.42.14.pom (4.0 kB at 77 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-youtrack-converter/0.42.14/flexmark-youtrack-converter-0.42.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-youtrack-converter/0.42.14/flexmark-youtrack-converter-0.42.14.pom (1.7 kB at 36 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-confluence/1.11.1/doxia-module-confluence-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-confluence/1.11.1/doxia-module-confluence-1.11.1.pom (2.2 kB at 44 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-docbook-simple/1.11.1/doxia-module-docbook-simple-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-docbook-simple/1.11.1/doxia-module-docbook-simple-1.11.1.pom (2.0 kB at 41 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-twiki/1.11.1/doxia-module-twiki-1.11.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-twiki/1.11.1/doxia-module-twiki-1.11.1.pom (2.1 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/1.0-alpha-30/plexus-container-default-1.0-alpha-30.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/1.0-alpha-30/plexus-container-default-1.0-alpha-30.pom (3.5 kB at 70 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.0-alpha-30/plexus-containers-1.0-alpha-30.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.0-alpha-30/plexus-containers-1.0-alpha-30.pom (1.9 kB at 39 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/1.0.11/plexus-1.0.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/1.0.11/plexus-1.0.11.pom (9.0 kB at 166 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/1.2-alpha-9/plexus-classworlds-1.2-alpha-9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-classworlds/1.2-alpha-9/plexus-classworlds-1.2-alpha-9.pom (3.2 kB at 66 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/junit/junit/3.8.1/junit-3.8.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/junit/junit/3.8.1/junit-3.8.1.pom (998 B at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/1.0-alpha-9-stable-1/plexus-container-default-1.0-alpha-9-stable-1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/1.0-alpha-9-stable-1/plexus-container-default-1.0-alpha-9-stable-1.pom (3.9 kB at 79 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.0.3/plexus-containers-1.0.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-containers/1.0.3/plexus-containers-1.0.3.pom (492 B at 10 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/1.0.4/plexus-1.0.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/1.0.4/plexus-1.0.4.pom (5.7 kB at 112 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/classworlds/classworlds/1.1-alpha-2/classworlds-1.1-alpha-2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/classworlds/classworlds/1.1-alpha-2/classworlds-1.1-alpha-2.pom (3.1 kB at 65 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-server/9.4.46.v20220331/jetty-server-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-server/9.4.46.v20220331/jetty-server-9.4.46.v20220331.pom (3.4 kB at 73 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-project/9.4.46.v20220331/jetty-project-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-project/9.4.46.v20220331/jetty-project-9.4.46.v20220331.pom (71 kB at 723 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.8.2/junit-bom-5.8.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.8.2/junit-bom-5.8.2.pom (5.6 kB at 110 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/testcontainers/testcontainers-bom/1.16.1/testcontainers-bom-1.16.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/testcontainers/testcontainers-bom/1.16.1/testcontainers-bom-1.16.1.pom (7.2 kB at 125 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-bom/11.0.15.Final/infinispan-bom-11.0.15.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-bom/11.0.15.Final/infinispan-bom-11.0.15.Final.pom (19 kB at 330 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-build-configuration-parent/11.0.15.Final/infinispan-build-configuration-parent-11.0.15.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/infinispan/infinispan-build-configuration-parent/11.0.15.Final/infinispan-build-configuration-parent-11.0.15.Final.pom (13 kB at 256 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/jboss-parent/36/jboss-parent-36.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/jboss-parent/36/jboss-parent-36.pom (66 kB at 765 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.pom (14 kB at 250 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-http/9.4.46.v20220331/jetty-http-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-http/9.4.46.v20220331/jetty-http-9.4.46.v20220331.pom (4.0 kB at 86 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util/9.4.46.v20220331/jetty-util-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util/9.4.46.v20220331/jetty-util-9.4.46.v20220331.pom (4.0 kB at 84 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-io/9.4.46.v20220331/jetty-io-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-io/9.4.46.v20220331/jetty-io-9.4.46.v20220331.pom (1.2 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.46.v20220331/jetty-servlet-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.46.v20220331/jetty-servlet-9.4.46.v20220331.pom (2.3 kB at 49 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-security/9.4.46.v20220331/jetty-security-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-security/9.4.46.v20220331/jetty-security-9.4.46.v20220331.pom (2.1 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util-ajax/9.4.46.v20220331/jetty-util-ajax-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util-ajax/9.4.46.v20220331/jetty-util-ajax-9.4.46.v20220331.pom (1.3 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-webapp/9.4.46.v20220331/jetty-webapp-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-webapp/9.4.46.v20220331/jetty-webapp-9.4.46.v20220331.pom (3.2 kB at 65 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-xml/9.4.46.v20220331/jetty-xml-9.4.46.v20220331.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-xml/9.4.46.v20220331/jetty-xml-9.4.46.v20220331.pom (1.7 kB at 36 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-exec/1.6.0/maven-reporting-exec-1.6.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/reporting/maven-reporting-exec/1.6.0/maven-reporting-exec-1.6.0.jar (31 kB at 477 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.5.2/maven-archiver-3.5.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.2.7/plexus-archiver-4.2.7.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.2.0/plexus-io-3.2.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.4.2/plexus-utils-3.4.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.5.2/maven-archiver-3.5.2.jar (26 kB at 236 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/2.1.0/plexus-container-default-2.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.2.0/plexus-io-3.2.0.jar (76 kB at 469 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/xbean/xbean-reflect/3.7/xbean-reflect-3.7.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/xbean/xbean-reflect/3.7/xbean-reflect-3.7.jar (148 kB at 190 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/collections/google-collections/1.0/google-collections-1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.2.7/plexus-archiver-4.2.7.jar (195 kB at 237 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.1.1/plexus-component-annotations-2.1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/3.4.2/plexus-utils-3.4.2.jar (267 kB at 317 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.3/commons-text-1.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/2.1.1/plexus-component-annotations-2.1.1.jar (4.1 kB at 4.0 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-apt/1.11.1/doxia-module-apt-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-container-default/2.1.0/plexus-container-default-2.1.0.jar (230 kB at 189 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xdoc/1.11.1/doxia-module-xdoc-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.jar (632 kB at 513 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-fml/1.11.1/doxia-module-fml-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-text/1.3/commons-text-1.3.jar (183 kB at 121 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-markdown/1.11.1/doxia-module-markdown-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-apt/1.11.1/doxia-module-apt-1.11.1.jar (55 kB at 36 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-all/0.42.14/flexmark-all-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/collections/google-collections/1.0/google-collections-1.0.jar (640 kB at 410 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark/0.42.14/flexmark-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-fml/1.11.1/doxia-module-fml-1.11.1.jar (38 kB at 24 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-abbreviation/0.42.14/flexmark-ext-abbreviation-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-xdoc/1.11.1/doxia-module-xdoc-1.11.1.jar (37 kB at 23 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-admonition/0.42.14/flexmark-ext-admonition-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-all/0.42.14/flexmark-all-0.42.14.jar (2.2 kB at 1.4 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-anchorlink/0.42.14/flexmark-ext-anchorlink-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-markdown/1.11.1/doxia-module-markdown-1.11.1.jar (18 kB at 11 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-aside/0.42.14/flexmark-ext-aside-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-anchorlink/0.42.14/flexmark-ext-anchorlink-0.42.14.jar (17 kB at 10 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-attributes/0.42.14/flexmark-ext-attributes-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-aside/0.42.14/flexmark-ext-aside-0.42.14.jar (16 kB at 9.6 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-autolink/0.42.14/flexmark-ext-autolink-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-abbreviation/0.42.14/flexmark-ext-abbreviation-0.42.14.jar (35 kB at 20 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/nibor/autolink/autolink/0.6.0/autolink-0.6.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark/0.42.14/flexmark-0.42.14.jar (389 kB at 214 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-definition/0.42.14/flexmark-ext-definition-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-attributes/0.42.14/flexmark-ext-attributes-0.42.14.jar (36 kB at 20 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-admonition/0.42.14/flexmark-ext-admonition-0.42.14.jar (34 kB at 19 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-emoji/0.42.14/flexmark-ext-emoji-0.42.14.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-enumerated-reference/0.42.14/flexmark-ext-enumerated-reference-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-autolink/0.42.14/flexmark-ext-autolink-0.42.14.jar (9.4 kB at 5.2 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-escaped-character/0.42.14/flexmark-ext-escaped-character-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/nibor/autolink/autolink/0.6.0/autolink-0.6.0.jar (16 kB at 8.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-footnotes/0.42.14/flexmark-ext-footnotes-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-escaped-character/0.42.14/flexmark-ext-escaped-character-0.42.14.jar (13 kB at 6.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-issues/0.42.14/flexmark-ext-gfm-issues-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-definition/0.42.14/flexmark-ext-definition-0.42.14.jar (40 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-strikethrough/0.42.14/flexmark-ext-gfm-strikethrough-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-footnotes/0.42.14/flexmark-ext-footnotes-0.42.14.jar (41 kB at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tables/0.42.14/flexmark-ext-gfm-tables-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-enumerated-reference/0.42.14/flexmark-ext-enumerated-reference-0.42.14.jar (66 kB at 34 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tasklist/0.42.14/flexmark-ext-gfm-tasklist-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-issues/0.42.14/flexmark-ext-gfm-issues-0.42.14.jar (16 kB at 8.0 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-emoji/0.42.14/flexmark-ext-emoji-0.42.14.jar (73 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-users/0.42.14/flexmark-ext-gfm-users-0.42.14.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gitlab/0.42.14/flexmark-ext-gitlab-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-strikethrough/0.42.14/flexmark-ext-gfm-strikethrough-0.42.14.jar (29 kB at 15 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-front-matter/0.42.14/flexmark-ext-jekyll-front-matter-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tables/0.42.14/flexmark-ext-gfm-tables-0.42.14.jar (33 kB at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-tag/0.42.14/flexmark-ext-jekyll-tag-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-tasklist/0.42.14/flexmark-ext-gfm-tasklist-0.42.14.jar (28 kB at 14 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-media-tags/0.42.14/flexmark-ext-media-tags-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-front-matter/0.42.14/flexmark-ext-jekyll-front-matter-0.42.14.jar (18 kB at 9.1 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-macros/0.42.14/flexmark-ext-macros-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gitlab/0.42.14/flexmark-ext-gitlab-0.42.14.jar (42 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-ins/0.42.14/flexmark-ext-ins-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-jekyll-tag/0.42.14/flexmark-ext-jekyll-tag-0.42.14.jar (21 kB at 10 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-xwiki-macros/0.42.14/flexmark-ext-xwiki-macros-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-gfm-users/0.42.14/flexmark-ext-gfm-users-0.42.14.jar (16 kB at 7.7 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-superscript/0.42.14/flexmark-ext-superscript-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-macros/0.42.14/flexmark-ext-macros-0.42.14.jar (35 kB at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-tables/0.42.14/flexmark-ext-tables-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-media-tags/0.42.14/flexmark-ext-media-tags-0.42.14.jar (25 kB at 12 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-ins/0.42.14/flexmark-ext-ins-0.42.14.jar (13 kB at 6.2 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-typographic/0.42.14/flexmark-ext-typographic-0.42.14.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-toc/0.42.14/flexmark-ext-toc-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-xwiki-macros/0.42.14/flexmark-ext-xwiki-macros-0.42.14.jar (31 kB at 15 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-wikilink/0.42.14/flexmark-ext-wikilink-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-superscript/0.42.14/flexmark-ext-superscript-0.42.14.jar (13 kB at 6.3 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-yaml-front-matter/0.42.14/flexmark-ext-yaml-front-matter-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-tables/0.42.14/flexmark-ext-tables-0.42.14.jar (76 kB at 35 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-youtube-embedded/0.42.14/flexmark-ext-youtube-embedded-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-typographic/0.42.14/flexmark-ext-typographic-0.42.14.jar (22 kB at 10 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-formatter/0.42.14/flexmark-formatter-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-yaml-front-matter/0.42.14/flexmark-ext-yaml-front-matter-0.42.14.jar (18 kB at 8.2 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-wikilink/0.42.14/flexmark-ext-wikilink-0.42.14.jar (26 kB at 12 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-html-parser/0.42.14/flexmark-html-parser-0.42.14.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jsoup/jsoup/1.10.2/jsoup-1.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-toc/0.42.14/flexmark-ext-toc-0.42.14.jar (91 kB at 41 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-jira-converter/0.42.14/flexmark-jira-converter-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-ext-youtube-embedded/0.42.14/flexmark-ext-youtube-embedded-0.42.14.jar (13 kB at 5.6 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-profile-pegdown/0.42.14/flexmark-profile-pegdown-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-html-parser/0.42.14/flexmark-html-parser-0.42.14.jar (45 kB at 19 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-util/0.42.14/flexmark-util-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-profile-pegdown/0.42.14/flexmark-profile-pegdown-0.42.14.jar (6.3 kB at 2.7 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-youtrack-converter/0.42.14/flexmark-youtrack-converter-0.42.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-formatter/0.42.14/flexmark-formatter-0.42.14.jar (97 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-confluence/1.11.1/doxia-module-confluence-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-jira-converter/0.42.14/flexmark-jira-converter-0.42.14.jar (40 kB at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-docbook-simple/1.11.1/doxia-module-docbook-simple-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-youtrack-converter/0.42.14/flexmark-youtrack-converter-0.42.14.jar (41 kB at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-twiki/1.11.1/doxia-module-twiki-1.11.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jsoup/jsoup/1.10.2/jsoup-1.10.2.jar (351 kB at 146 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-server/9.4.46.v20220331/jetty-server-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-confluence/1.11.1/doxia-module-confluence-1.11.1.jar (58 kB at 24 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-twiki/1.11.1/doxia-module-twiki-1.11.1.jar (73 kB at 29 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-http/9.4.46.v20220331/jetty-http-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/doxia/doxia-module-docbook-simple/1.11.1/doxia-module-docbook-simple-1.11.1.jar (128 kB at 51 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-io/9.4.46.v20220331/jetty-io-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vladsch/flexmark/flexmark-util/0.42.14/flexmark-util-0.42.14.jar (385 kB at 151 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.46.v20220331/jetty-servlet-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar (96 kB at 37 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-security/9.4.46.v20220331/jetty-security-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-http/9.4.46.v20220331/jetty-http-9.4.46.v20220331.jar (225 kB at 86 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util-ajax/9.4.46.v20220331/jetty-util-ajax-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.46.v20220331/jetty-servlet-9.4.46.v20220331.jar (147 kB at 54 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-webapp/9.4.46.v20220331/jetty-webapp-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util-ajax/9.4.46.v20220331/jetty-util-ajax-9.4.46.v20220331.jar (67 kB at 24 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-xml/9.4.46.v20220331/jetty-xml-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-io/9.4.46.v20220331/jetty-io-9.4.46.v20220331.jar (184 kB at 64 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util/9.4.46.v20220331/jetty-util-9.4.46.v20220331.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-security/9.4.46.v20220331/jetty-security-9.4.46.v20220331.jar (119 kB at 41 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-server/9.4.46.v20220331/jetty-server-9.4.46.v20220331.jar (733 kB at 255 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-webapp/9.4.46.v20220331/jetty-webapp-9.4.46.v20220331.jar (141 kB at 48 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-xml/9.4.46.v20220331/jetty-xml-9.4.46.v20220331.jar (69 kB at 23 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-util/9.4.46.v20220331/jetty-util-9.4.46.v20220331.jar (586 kB at 184 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/4.0.0/plexus-utils-4.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/4.0.0/plexus-utils-4.0.0.jar (192 kB at 1.7 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-buildpack-platform/3.2.3/spring-boot-buildpack-platform-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-buildpack-platform/3.2.3/spring-boot-buildpack-platform-3.2.3.pom (3.2 kB at 71 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.14.2/jackson-databind-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.14.2/jackson-databind-2.14.2.pom (19 kB at 390 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-base/2.14.2/jackson-base-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-base/2.14.2/jackson-base-2.14.2.pom (10 kB at 205 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.14.2/jackson-bom-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.14.2/jackson-bom-2.14.2.pom (17 kB at 324 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-parent/2.14/jackson-parent-2.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-parent/2.14/jackson-parent-2.14.pom (7.7 kB at 132 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/48/oss-parent-48.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/48/oss-parent-48.pom (24 kB at 371 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.14.2/jackson-annotations-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.14.2/jackson-annotations-2.14.2.pom (6.2 kB at 124 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.14.2/jackson-core-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.14.2/jackson-core-2.14.2.pom (7.0 kB at 149 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.14.2/jackson-module-parameter-names-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.14.2/jackson-module-parameter-names-2.14.2.pom (4.4 kB at 91 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-modules-java8/2.14.2/jackson-modules-java8-2.14.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-modules-java8/2.14.2/jackson-modules-java8-2.14.2.pom (3.1 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.pom (2.3 kB at 50 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.13.0/jna-5.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.13.0/jna-5.13.0.pom (2.0 kB at 44 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.2.3/httpclient5-5.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.2.3/httpclient5-5.2.3.pom (6.0 kB at 130 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/client5/httpclient5-parent/5.2.3/httpclient5-parent-5.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/client5/httpclient5-parent/5.2.3/httpclient5-parent-5.2.3.pom (17 kB at 345 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-parent/13/httpcomponents-parent-13.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/httpcomponents-parent/13/httpcomponents-parent-13.pom (30 kB at 581 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5/5.2.4/httpcore5-5.2.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5/5.2.4/httpcore5-5.2.4.pom (3.9 kB at 90 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5-parent/5.2.4/httpcore5-parent-5.2.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5-parent/5.2.4/httpcore5-parent-5.2.4.pom (14 kB at 269 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5-h2/5.2.4/httpcore5-h2-5.2.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5-h2/5.2.4/httpcore5-h2-5.2.4.pom (3.6 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.0.10/spring-core-6.0.10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.0.10/spring-core-6.0.10.pom (2.0 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.0.10/spring-jcl-6.0.10.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.0.10/spring-jcl-6.0.10.pom (1.8 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/tomlj/tomlj/1.0.0/tomlj-1.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/tomlj/tomlj/1.0.0/tomlj-1.0.0.pom (2.8 kB at 60 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.7.2/antlr4-runtime-4.7.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.7.2/antlr4-runtime-4.7.2.pom (3.6 kB at 80 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-master/4.7.2/antlr4-master-4.7.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-master/4.7.2/antlr4-master-4.7.2.pom (4.4 kB at 98 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.pom (4.3 kB at 74 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-loader-tools/3.2.3/spring-boot-loader-tools-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-loader-tools/3.2.3/spring-boot-loader-tools-3.2.3.pom (2.2 kB at 50 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-context/6.1.4/spring-context-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-context/6.1.4/spring-context-6.1.4.pom (2.8 kB at 59 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aop/6.1.4/spring-aop-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aop/6.1.4/spring-aop-6.1.4.pom (2.2 kB at 44 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-beans/6.1.4/spring-beans-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-beans/6.1.4/spring-beans-6.1.4.pom (2.0 kB at 44 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.1.4/spring-core-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.1.4/spring-core-6.1.4.pom (2.0 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.1.4/spring-jcl-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.1.4/spring-jcl-6.1.4.pom (1.8 kB at 41 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-expression/6.1.4/spring-expression-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-expression/6.1.4/spring-expression-6.1.4.pom (2.1 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-observation/1.12.3/micrometer-observation-1.12.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-observation/1.12.3/micrometer-observation-1.12.3.pom (3.8 kB at 82 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-commons/1.12.3/micrometer-commons-1.12.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-commons/1.12.3/micrometer-commons-1.12.3.pom (3.4 kB at 74 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/1.5.8/plexus-utils-1.5.8.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/1.5.8/plexus-utils-1.5.8.pom (8.1 kB at 172 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.2/plexus-2.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus/2.0.2/plexus-2.0.2.pom (12 kB at 247 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-shade-plugin/3.5.0/maven-shade-plugin-3.5.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-shade-plugin/3.5.0/maven-shade-plugin-3.5.0.pom (12 kB at 259 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.32/slf4j-api-1.7.32.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.32/slf4j-api-1.7.32.pom (3.8 kB at 87 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.32/slf4j-parent-1.7.32.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.32/slf4j-parent-1.7.32.pom (14 kB at 288 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-commons/9.5/asm-commons-9.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-commons/9.5/asm-commons-9.5.pom (2.8 kB at 62 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-tree/9.5/asm-tree-9.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-tree/9.5/asm-tree-9.5.pom (2.6 kB at 49 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jdom/jdom2/2.0.6.1/jdom2-2.0.6.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jdom/jdom2/2.0.6.1/jdom2-2.0.6.1.pom (4.6 kB at 96 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/vafer/jdependency/2.8.0/jdependency-2.8.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/vafer/jdependency/2.8.0/jdependency-2.8.0.pom (14 kB at 220 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-buildpack-platform/3.2.3/spring-boot-buildpack-platform-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-buildpack-platform/3.2.3/spring-boot-buildpack-platform-3.2.3.jar (272 kB at 1.9 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.14.2/jackson-databind-2.14.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.14.2/jackson-annotations-2.14.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.14.2/jackson-core-2.14.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.14.2/jackson-module-parameter-names-2.14.2.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.14.2/jackson-module-parameter-names-2.14.2.jar (9.5 kB at 158 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.14.2/jackson-annotations-2.14.2.jar (77 kB at 1.0 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.14.2/jackson-core-2.14.2.jar (459 kB at 1.1 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.2.3/httpclient5-5.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar (1.0 MB at 1.8 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5/5.2.4/httpcore5-5.2.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5/5.2.4/httpcore5-5.2.4.jar (855 kB at 826 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5-h2/5.2.4/httpcore5-h2-5.2.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/core5/httpcore5-h2/5.2.4/httpcore5-h2-5.2.4.jar (237 kB at 186 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.0.10/spring-core-6.0.10.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar (1.9 MB at 1.4 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.0.10/spring-jcl-6.0.10.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.2.3/httpclient5-5.2.3.jar (843 kB at 618 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/tomlj/tomlj/1.0.0/tomlj-1.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.0.10/spring-jcl-6.0.10.jar (24 kB at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.7.2/antlr4-runtime-4.7.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/tomlj/tomlj/1.0.0/tomlj-1.0.0.jar (157 kB at 96 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.jar (1.4 MB at 793 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-loader-tools/3.2.3/spring-boot-loader-tools-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.7.2/antlr4-runtime-4.7.2.jar (338 kB at 191 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-context/6.1.4/spring-context-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar (20 kB at 11 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aop/6.1.4/spring-aop-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.0.10/spring-core-6.0.10.jar (1.8 MB at 906 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-beans/6.1.4/spring-beans-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.14.2/jackson-databind-2.14.2.jar (1.6 MB at 795 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-expression/6.1.4/spring-expression-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-loader-tools/3.2.3/spring-boot-loader-tools-3.2.3.jar (434 kB at 188 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-observation/1.12.3/micrometer-observation-1.12.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-observation/1.12.3/micrometer-observation-1.12.3.jar (72 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-commons/1.12.3/micrometer-commons-1.12.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-beans/6.1.4/spring-beans-6.1.4.jar (857 kB at 313 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/1.5.8/plexus-utils-1.5.8.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aop/6.1.4/spring-aop-6.1.4.jar (416 kB at 151 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-shade-plugin/3.5.0/maven-shade-plugin-3.5.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-expression/6.1.4/spring-expression-6.1.4.jar (302 kB at 110 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-commons/9.5/asm-commons-9.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-context/6.1.4/spring-context-6.1.4.jar (1.3 MB at 470 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-tree/9.5/asm-tree-9.5.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/micrometer/micrometer-commons/1.12.3/micrometer-commons-1.12.3.jar (47 kB at 17 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jdom/jdom2/2.0.6.1/jdom2-2.0.6.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-tree/9.5/asm-tree-9.5.jar (52 kB at 18 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/vafer/jdependency/2.8.0/jdependency-2.8.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-utils/1.5.8/plexus-utils-1.5.8.jar (268 kB at 92 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-commons/9.5/asm-commons-9.5.jar (72 kB at 25 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-shade-plugin/3.5.0/maven-shade-plugin-3.5.0.jar (147 kB at 49 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/vafer/jdependency/2.8.0/jdependency-2.8.0.jar (233 kB at 75 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jdom/jdom2/2.0.6.1/jdom2-2.0.6.1.jar (328 kB at 105 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/file-management/3.1.0/file-management-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/file-management/3.1.0/file-management-3.1.0.pom (4.5 kB at 98 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/36/maven-shared-components-36.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/maven-shared-components/36/maven-shared-components-36.pom (4.9 kB at 100 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.6.0/maven-archiver-3.6.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.6.0/maven-archiver-3.6.0.pom (3.9 kB at 83 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.0/plexus-io-3.4.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.0/plexus-io-3.4.0.pom (6.0 kB at 118 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.4.0/plexus-archiver-4.4.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.4.0/plexus-archiver-4.4.0.pom (6.3 kB at 103 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/file-management/3.1.0/file-management-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/shared/file-management/3.1.0/file-management-3.1.0.jar (36 kB at 519 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.6.0/maven-archiver-3.6.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.0/plexus-io-3.4.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.4.0/plexus-archiver-4.4.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-archiver/3.6.0/maven-archiver-3.6.0.jar (26 kB at 416 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-io/3.4.0/plexus-io-3.4.0.jar (79 kB at 763 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-archiver/4.4.0/plexus-archiver-4.4.0.jar (211 kB at 1.3 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-web/3.2.3/spring-boot-starter-web-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-web/3.2.3/spring-boot-starter-web-3.2.3.pom (2.9 kB at 52 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter/3.2.3/spring-boot-starter-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter/3.2.3/spring-boot-starter-3.2.3.pom (3.0 kB at 66 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot/3.2.3/spring-boot-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot/3.2.3/spring-boot-3.2.3.pom (2.2 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-autoconfigure/3.2.3/spring-boot-autoconfigure-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-autoconfigure/3.2.3/spring-boot-autoconfigure-3.2.3.pom (2.1 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-logging/3.2.3/spring-boot-starter-logging-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-logging/3.2.3/spring-boot-starter-logging-3.2.3.pom (2.5 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.4.14/logback-classic-1.4.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.4.14/logback-classic-1.4.14.pom (13 kB at 267 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-parent/1.4.14/logback-parent-1.4.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-parent/1.4.14/logback-parent-1.4.14.pom (20 kB at 387 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.4.14/logback-core-1.4.14.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.4.14/logback-core-1.4.14.pom (5.0 kB at 80 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.7/slf4j-api-2.0.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.7/slf4j-api-2.0.7.pom (2.7 kB at 57 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.7/slf4j-parent-2.0.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.7/slf4j-parent-2.0.7.pom (17 kB at 342 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-to-slf4j/2.21.1/log4j-to-slf4j-2.21.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-to-slf4j/2.21.1/log4j-to-slf4j-2.21.1.pom (4.2 kB at 88 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j/2.21.1/log4j-2.21.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j/2.21.1/log4j-2.21.1.pom (35 kB at 655 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-bom/9.5/asm-bom-9.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm-bom/9.5/asm-bom-9.5.pom (3.2 kB at 70 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/groovy/groovy-bom/3.0.19/groovy-bom-3.0.19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/groovy/groovy-bom/3.0.19/groovy-bom-3.0.19.pom (26 kB at 489 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.15.2/jackson-bom-2.15.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.15.2/jackson-bom-2.15.2.pom (18 kB at 367 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/platform/jakarta.jakartaee-bom/9.1.0/jakarta.jakartaee-bom-9.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/platform/jakarta.jakartaee-bom/9.1.0/jakarta.jakartaee-bom-9.1.0.pom (9.6 kB at 199 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/platform/jakartaee-api-parent/9.1.0/jakartaee-api-parent-9.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/platform/jakartaee-api-parent/9.1.0/jakartaee-api-parent-9.1.0.pom (15 kB at 303 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/ee4j/project/1.0.7/project-1.0.7.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/ee4j/project/1.0.7/project-1.0.7.pom (14 kB at 289 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-bom/9.4.53.v20231009/jetty-bom-9.4.53.v20231009.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/jetty/jetty-bom/9.4.53.v20231009/jetty-bom-9.4.53.v20231009.pom (18 kB at 346 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.10.0/junit-bom-5.10.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/junit-bom/5.10.0/junit-bom-5.10.0.pom (5.6 kB at 118 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/fabric8/kubernetes-client-bom/5.12.4/kubernetes-client-bom-5.12.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/fabric8/kubernetes-client-bom/5.12.4/kubernetes-client-bom-5.12.4.pom (26 kB at 484 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-bom/4.11.0/mockito-bom-4.11.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-bom/4.11.0/mockito-bom-4.11.0.pom (3.2 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/netty/netty-bom/4.1.97.Final/netty-bom-4.1.97.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/netty/netty-bom/4.1.97.Final/netty-bom-4.1.97.Final.pom (13 kB at 271 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-framework-bom/5.3.29/spring-framework-bom-5.3.29.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-framework-bom/5.3.29/spring-framework-bom-5.3.29.pom (5.7 kB at 120 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-api/2.21.1/log4j-api-2.21.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-api/2.21.1/log4j-api-2.21.1.pom (4.0 kB at 84 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/jul-to-slf4j/2.0.12/jul-to-slf4j-2.0.12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/jul-to-slf4j/2.0.12/jul-to-slf4j-2.0.12.pom (1.1 kB at 24 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.12/slf4j-parent-2.0.12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.12/slf4j-parent-2.0.12.pom (13 kB at 257 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-bom/2.0.12/slf4j-bom-2.0.12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-bom/2.0.12/slf4j-bom-2.0.12.pom (7.3 kB at 150 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.pom (2.8 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.pom (16 kB at 282 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/yaml/snakeyaml/2.2/snakeyaml-2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/yaml/snakeyaml/2.2/snakeyaml-2.2.pom (21 kB at 354 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-json/3.2.3/spring-boot-starter-json-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-json/3.2.3/spring-boot-starter-json-3.2.3.pom (3.1 kB at 64 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-web/6.1.4/spring-web-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-web/6.1.4/spring-web-6.1.4.pom (2.4 kB at 47 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.4/jackson-databind-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.4/jackson-databind-2.15.4.pom (19 kB at 394 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-base/2.15.4/jackson-base-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-base/2.15.4/jackson-base-2.15.4.pom (11 kB at 179 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.4/jackson-annotations-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.4/jackson-annotations-2.15.4.pom (7.1 kB at 131 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.4/jackson-core-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.4/jackson-core-2.15.4.pom (9.9 kB at 179 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.15.4/jackson-datatype-jdk8-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.15.4/jackson-datatype-jdk8-2.15.4.pom (2.6 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-modules-java8/2.15.4/jackson-modules-java8-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-modules-java8/2.15.4/jackson-modules-java8-2.15.4.pom (3.1 kB at 65 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.15.4/jackson-datatype-jsr310-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.15.4/jackson-datatype-jsr310-2.15.4.pom (4.9 kB at 93 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.15.4/jackson-module-parameter-names-2.15.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.15.4/jackson-module-parameter-names-2.15.4.pom (4.4 kB at 79 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-tomcat/3.2.3/spring-boot-starter-tomcat-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-tomcat/3.2.3/spring-boot-starter-tomcat-3.2.3.pom (3.1 kB at 64 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-core/10.1.19/tomcat-embed-core-10.1.19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-core/10.1.19/tomcat-embed-core-10.1.19.pom (1.7 kB at 37 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-el/10.1.19/tomcat-embed-el-10.1.19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-el/10.1.19/tomcat-embed-el-10.1.19.pom (1.5 kB at 33 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-websocket/10.1.19/tomcat-embed-websocket-10.1.19.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-websocket/10.1.19/tomcat-embed-websocket-10.1.19.pom (1.7 kB at 37 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-webmvc/6.1.4/spring-webmvc-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-webmvc/6.1.4/spring-webmvc-6.1.4.pom (2.9 kB at 61 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-web/3.2.3/spring-boot-starter-web-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-web/3.2.3/spring-boot-starter-web-3.2.3.jar (4.8 kB at 102 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter/3.2.3/spring-boot-starter-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot/3.2.3/spring-boot-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-autoconfigure/3.2.3/spring-boot-autoconfigure-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-logging/3.2.3/spring-boot-starter-logging-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.4.14/logback-classic-1.4.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter/3.2.3/spring-boot-starter-3.2.3.jar (4.8 kB at 73 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.4.14/logback-core-1.4.14.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-logging/3.2.3/spring-boot-starter-logging-3.2.3.jar (4.8 kB at 76 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.7/slf4j-api-2.0.7.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.7/slf4j-api-2.0.7.jar (64 kB at 310 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-to-slf4j/2.21.1/log4j-to-slf4j-2.21.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.4.14/logback-classic-1.4.14.jar (284 kB at 1.3 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-api/2.21.1/log4j-api-2.21.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-to-slf4j/2.21.1/log4j-to-slf4j-2.21.1.jar (23 kB at 75 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/jul-to-slf4j/2.0.12/jul-to-slf4j-2.0.12.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-api/2.21.1/log4j-api-2.21.1.jar (317 kB at 752 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/jul-to-slf4j/2.0.12/jul-to-slf4j-2.0.12.jar (6.3 kB at 14 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.1.4/spring-core-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.jar (26 kB at 49 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.1.4/spring-jcl-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jcl/6.1.4/spring-jcl-6.1.4.jar (25 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/yaml/snakeyaml/2.2/snakeyaml-2.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.4.14/logback-core-1.4.14.jar (597 kB at 795 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-json/3.2.3/spring-boot-starter-json-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/yaml/snakeyaml/2.2/snakeyaml-2.2.jar (334 kB at 327 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.4/jackson-databind-2.15.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-json/3.2.3/spring-boot-starter-json-3.2.3.jar (4.7 kB at 4.3 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.4/jackson-annotations-2.15.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-autoconfigure/3.2.3/spring-boot-autoconfigure-3.2.3.jar (1.9 MB at 1.5 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.4/jackson-core-2.15.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.4/jackson-annotations-2.15.4.jar (76 kB at 57 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.15.4/jackson-datatype-jdk8-2.15.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.15.4/jackson-datatype-jdk8-2.15.4.jar (36 kB at 23 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.15.4/jackson-datatype-jsr310-2.15.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.4/jackson-core-2.15.4.jar (548 kB at 307 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.15.4/jackson-module-parameter-names-2.15.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot/3.2.3/spring-boot-3.2.3.jar (1.6 MB at 880 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-tomcat/3.2.3/spring-boot-starter-tomcat-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-core/6.1.4/spring-core-6.1.4.jar (1.9 MB at 1.0 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-core/10.1.19/tomcat-embed-core-10.1.19.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.4/jackson-databind-2.15.4.jar (1.6 MB at 859 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-el/10.1.19/tomcat-embed-el-10.1.19.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.15.4/jackson-datatype-jsr310-2.15.4.jar (123 kB at 65 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-websocket/10.1.19/tomcat-embed-websocket-10.1.19.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/module/jackson-module-parameter-names/2.15.4/jackson-module-parameter-names-2.15.4.jar (10 kB at 5.5 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-tomcat/3.2.3/spring-boot-starter-tomcat-3.2.3.jar (4.8 kB at 2.5 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-web/6.1.4/spring-web-6.1.4.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-webmvc/6.1.4/spring-webmvc-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-el/10.1.19/tomcat-embed-el-10.1.19.jar (261 kB at 126 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-websocket/10.1.19/tomcat-embed-websocket-10.1.19.jar (282 kB at 121 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-webmvc/6.1.4/spring-webmvc-6.1.4.jar (1.0 MB at 405 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/tomcat/embed/tomcat-embed-core/10.1.19/tomcat-embed-core-10.1.19.jar (3.5 MB at 1.1 MB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-web/6.1.4/spring-web-6.1.4.jar (1.9 MB at 576 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-data-jpa/3.2.3/spring-boot-starter-data-jpa-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-data-jpa/3.2.3/spring-boot-starter-data-jpa-3.2.3.pom (2.9 kB at 59 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-aop/3.2.3/spring-boot-starter-aop-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-aop/3.2.3/spring-boot-starter-aop-3.2.3.pom (2.5 kB at 55 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/aspectj/aspectjweaver/1.9.21/aspectjweaver-1.9.21.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/aspectj/aspectjweaver/1.9.21/aspectjweaver-1.9.21.pom (2.1 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-jdbc/3.2.3/spring-boot-starter-jdbc-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-jdbc/3.2.3/spring-boot-starter-jdbc-3.2.3.pom (2.5 kB at 52 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/zaxxer/HikariCP/5.0.1/HikariCP-5.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/zaxxer/HikariCP/5.0.1/HikariCP-5.0.1.pom (25 kB at 494 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.0-alpha1/slf4j-api-2.0.0-alpha1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.0-alpha1/slf4j-api-2.0.0-alpha1.pom (1.7 kB at 35 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.0-alpha1/slf4j-parent-2.0.0-alpha1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.0-alpha1/slf4j-parent-2.0.0-alpha1.pom (16 kB at 150 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jdbc/6.1.4/spring-jdbc-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jdbc/6.1.4/spring-jdbc-6.1.4.pom (2.4 kB at 47 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-tx/6.1.4/spring-tx-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-tx/6.1.4/spring-tx-6.1.4.pom (2.2 kB at 48 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hibernate/orm/hibernate-core/6.4.4.Final/hibernate-core-6.4.4.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hibernate/orm/hibernate-core/6.4.4.Final/hibernate-core-6.4.4.Final.pom (5.8 kB at 117 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/persistence/jakarta.persistence-api/3.1.0/jakarta.persistence-api-3.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/persistence/jakarta.persistence-api/3.1.0/jakarta.persistence-api-3.1.0.pom (16 kB at 317 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/transaction/jakarta.transaction-api/2.0.1/jakarta.transaction-api-2.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/transaction/jakarta.transaction-api/2.0.1/jakarta.transaction-api-2.0.1.pom (14 kB at 267 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/ee4j/project/1.0.6/project-1.0.6.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/ee4j/project/1.0.6/project-1.0.6.pom (13 kB at 278 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.0.Final/jboss-logging-3.5.0.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.0.Final/jboss-logging-3.5.0.Final.pom (18 kB at 338 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hibernate/common/hibernate-commons-annotations/6.0.6.Final/hibernate-commons-annotations-6.0.6.Final.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hibernate/common/hibernate-commons-annotations/6.0.6.Final/hibernate-commons-annotations-6.0.6.Final.pom (2.1 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/smallrye/jandex/3.1.2/jandex-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/smallrye/jandex/3.1.2/jandex-3.1.2.pom (7.0 kB at 151 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/smallrye/jandex-parent/3.1.2/jandex-parent-3.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/smallrye/jandex-parent/3.1.2/jandex-parent-3.1.2.pom (7.2 kB at 155 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/smallrye/smallrye-build-parent/39/smallrye-build-parent-39.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/smallrye/smallrye-build-parent/39/smallrye-build-parent-39.pom (28 kB at 545 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.5.1/classmate-1.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.5.1/classmate-1.5.1.pom (7.3 kB at 155 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/35/oss-parent-35.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/35/oss-parent-35.pom (23 kB at 430 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.11/byte-buddy-1.14.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.11/byte-buddy-1.14.11.pom (16 kB at 317 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.14.11/byte-buddy-parent-1.14.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.14.11/byte-buddy-parent-1.14.11.pom (62 kB at 1.0 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.0/jakarta.xml.bind-api-4.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.0/jakarta.xml.bind-api-4.0.0.pom (12 kB at 244 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api-parent/4.0.0/jakarta.xml.bind-api-parent-4.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api-parent/4.0.0/jakarta.xml.bind-api-parent-4.0.0.pom (9.2 kB at 191 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.0/jakarta.activation-api-2.1.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.0/jakarta.activation-api-2.1.0.pom (18 kB at 352 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.2/jaxb-runtime-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.2/jaxb-runtime-4.0.2.pom (4.8 kB at 95 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-runtime-parent/4.0.2/jaxb-runtime-parent-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-runtime-parent/4.0.2/jaxb-runtime-parent-4.0.2.pom (1.2 kB at 25 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-parent/4.0.2/jaxb-parent-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-parent/4.0.2/jaxb-parent-4.0.2.pom (33 kB at 588 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/jaxb-bom-ext/4.0.2/jaxb-bom-ext-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/jaxb-bom-ext/4.0.2/jaxb-bom-ext-4.0.2.pom (3.5 kB at 69 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-bom/4.0.2/jaxb-bom-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-bom/4.0.2/jaxb-bom-4.0.2.pom (11 kB at 149 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.2/jaxb-core-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.2/jaxb-core-4.0.2.pom (3.7 kB at 70 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.1/jakarta.activation-api-2.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.1/jakarta.activation-api-2.1.1.pom (18 kB at 375 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.0/angus-activation-2.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.0/angus-activation-2.0.0.pom (4.1 kB at 82 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation-project/2.0.0/angus-activation-project-2.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation-project/2.0.0/angus-activation-project-2.0.0.pom (20 kB at 333 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.2/txw2-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.2/txw2-4.0.2.pom (1.8 kB at 36 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-txw-parent/4.0.2/jaxb-txw-parent-4.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-txw-parent/4.0.2/jaxb-txw-parent-4.0.2.pom (1.2 kB at 25 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.1/istack-commons-runtime-4.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.1/istack-commons-runtime-4.1.1.pom (2.3 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons/4.1.1/istack-commons-4.1.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons/4.1.1/istack-commons-4.1.1.pom (24 kB at 475 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/inject/jakarta.inject-api/2.0.1/jakarta.inject-api-2.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/inject/jakarta.inject-api/2.0.1/jakarta.inject-api-2.0.1.pom (5.9 kB at 114 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.13.0/antlr4-runtime-4.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.13.0/antlr4-runtime-4.13.0.pom (3.6 kB at 76 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-master/4.13.0/antlr4-master-4.13.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-master/4.13.0/antlr4-master-4.13.0.pom (4.8 kB at 72 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-jpa/3.2.3/spring-data-jpa-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-jpa/3.2.3/spring-data-jpa-3.2.3.pom (11 kB at 222 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-jpa-parent/3.2.3/spring-data-jpa-parent-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-jpa-parent/3.2.3/spring-data-jpa-parent-3.2.3.pom (6.9 kB at 135 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/build/spring-data-parent/3.2.3/spring-data-parent-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/build/spring-data-parent/3.2.3/spring-data-parent-3.2.3.pom (41 kB at 744 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/build/spring-data-build/3.2.3/spring-data-build-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/build/spring-data-build/3.2.3/spring-data-build-3.2.3.pom (7.2 kB at 156 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.15.3/jackson-bom-2.15.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/jackson/jackson-bom/2.15.3/jackson-bom-2.15.3.pom (18 kB at 367 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-commons/3.2.3/spring-data-commons-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-commons/3.2.3/spring-data-commons-3.2.3.pom (10 kB at 205 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.2/slf4j-api-2.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.2/slf4j-api-2.0.2.pom (1.6 kB at 31 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.2/slf4j-parent-2.0.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.2/slf4j-parent-2.0.2.pom (16 kB at 265 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-orm/6.1.4/spring-orm-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-orm/6.1.4/spring-orm-6.1.4.pom (2.6 kB at 56 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.0.0/jakarta.annotation-api-2.0.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.0.0/jakarta.annotation-api-2.0.0.pom (16 kB at 326 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aspects/6.1.4/spring-aspects-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aspects/6.1.4/spring-aspects-6.1.4.pom (2.0 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-data-jpa/3.2.3/spring-boot-starter-data-jpa-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-data-jpa/3.2.3/spring-boot-starter-data-jpa-3.2.3.jar (4.8 kB at 88 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-aop/3.2.3/spring-boot-starter-aop-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/aspectj/aspectjweaver/1.9.21/aspectjweaver-1.9.21.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-jdbc/3.2.3/spring-boot-starter-jdbc-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/zaxxer/HikariCP/5.0.1/HikariCP-5.0.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jdbc/6.1.4/spring-jdbc-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-aop/3.2.3/spring-boot-starter-aop-3.2.3.jar (4.8 kB at 88 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hibernate/orm/hibernate-core/6.4.4.Final/hibernate-core-6.4.4.Final.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-jdbc/3.2.3/spring-boot-starter-jdbc-3.2.3.jar (4.8 kB at 88 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/persistence/jakarta.persistence-api/3.1.0/jakarta.persistence-api-3.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-jdbc/6.1.4/spring-jdbc-6.1.4.jar (466 kB at 1.7 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/transaction/jakarta.transaction-api/2.0.1/jakarta.transaction-api-2.0.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/persistence/jakarta.persistence-api/3.1.0/jakarta.persistence-api-3.1.0.jar (165 kB at 549 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.0.Final/jboss-logging-3.5.0.Final.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/zaxxer/HikariCP/5.0.1/HikariCP-5.0.1.jar (162 kB at 469 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hibernate/common/hibernate-commons-annotations/6.0.6.Final/hibernate-commons-annotations-6.0.6.Final.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/transaction/jakarta.transaction-api/2.0.1/jakarta.transaction-api-2.0.1.jar (29 kB at 65 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/io/smallrye/jandex/3.1.2/jandex-3.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.0.Final/jboss-logging-3.5.0.Final.jar (63 kB at 124 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.5.1/classmate-1.5.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hibernate/common/hibernate-commons-annotations/6.0.6.Final/hibernate-commons-annotations-6.0.6.Final.jar (68 kB at 122 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.11/byte-buddy-1.14.11.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/io/smallrye/jandex/3.1.2/jandex-3.1.2.jar (327 kB at 444 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.0/jakarta.xml.bind-api-4.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.5.1/classmate-1.5.1.jar (68 kB at 88 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.0/jakarta.activation-api-2.1.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.0/jakarta.xml.bind-api-4.0.0.jar (127 kB at 130 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.2/jaxb-runtime-4.0.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.0/jakarta.activation-api-2.1.0.jar (63 kB at 60 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.2/jaxb-core-4.0.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/aspectj/aspectjweaver/1.9.21/aspectjweaver-1.9.21.jar (2.1 MB at 1.9 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.0/angus-activation-2.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.0/angus-activation-2.0.0.jar (27 kB at 21 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.2/txw2-4.0.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.2/jaxb-core-4.0.2.jar (139 kB at 94 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.1/istack-commons-runtime-4.1.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.2/jaxb-runtime-4.0.2.jar (908 kB at 584 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/inject/jakarta.inject-api/2.0.1/jakarta.inject-api-2.0.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.2/txw2-4.0.2.jar (73 kB at 46 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.13.0/antlr4-runtime-4.13.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.1/istack-commons-runtime-4.1.1.jar (26 kB at 16 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-jpa/3.2.3/spring-data-jpa-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/inject/jakarta.inject-api/2.0.1/jakarta.inject-api-2.0.1.jar (11 kB at 6.2 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-commons/3.2.3/spring-data-commons-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/antlr/antlr4-runtime/4.13.0/antlr4-runtime-4.13.0.jar (326 kB at 166 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-orm/6.1.4/spring-orm-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-orm/6.1.4/spring-orm-6.1.4.jar (235 kB at 75 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-tx/6.1.4/spring-tx-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-commons/3.2.3/spring-data-commons-3.2.3.jar (1.4 MB at 376 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.0.0/jakarta.annotation-api-2.0.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/annotation/jakarta.annotation-api/2.0.0/jakarta.annotation-api-2.0.0.jar (25 kB at 5.8 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.2/slf4j-api-2.0.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.2/slf4j-api-2.0.2.jar (61 kB at 12 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aspects/6.1.4/spring-aspects-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-aspects/6.1.4/spring-aspects-6.1.4.jar (50 kB at 8.2 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-tx/6.1.4/spring-tx-6.1.4.jar (284 kB at 39 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-jpa/3.2.3/spring-data-jpa-3.2.3.jar (1.5 MB at 183 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hibernate/orm/hibernate-core/6.4.4.Final/hibernate-core-6.4.4.Final.jar (12 MB at 1.2 MB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.11/byte-buddy-1.14.11.jar (4.2 MB at 397 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/projectlombok/lombok/1.18.30/lombok-1.18.30.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/projectlombok/lombok/1.18.30/lombok-1.18.30.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar (2.0 MB at 2.9 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/postgresql/postgresql/42.6.1/postgresql-42.6.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/postgresql/postgresql/42.6.1/postgresql-42.6.1.pom (2.7 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/checkerframework/checker-qual/3.31.0/checker-qual-3.31.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/checkerframework/checker-qual/3.31.0/checker-qual-3.31.0.pom (2.1 kB at 48 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/waffle/waffle-jna/1.9.1/waffle-jna-1.9.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/waffle/waffle-jna/1.9.1/waffle-jna-1.9.1.pom (3.1 kB at 67 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/waffle/waffle-parent/1.9.1/waffle-parent-1.9.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/waffle/waffle-parent/1.9.1/waffle-parent-1.9.1.pom (67 kB at 1.2 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/4.5.1/jna-4.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/4.5.1/jna-4.5.1.pom (1.6 kB at 35 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/4.5.1/jna-platform-4.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/4.5.1/jna-platform-4.5.1.pom (1.8 kB at 38 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/jcl-over-slf4j/1.7.25/jcl-over-slf4j-1.7.25.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/jcl-over-slf4j/1.7.25/jcl-over-slf4j-1.7.25.pom (959 B at 22 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.25/slf4j-parent-1.7.25.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.25/slf4j-parent-1.7.25.pom (14 kB at 300 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.pom (3.8 kB at 85 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/ben-manes/caffeine/caffeine/2.6.2/caffeine-2.6.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/ben-manes/caffeine/caffeine/2.6.2/caffeine-2.6.2.pom (5.6 kB at 122 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/postgresql/postgresql/42.6.1/postgresql-42.6.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/postgresql/postgresql/42.6.1/postgresql-42.6.1.jar (1.1 MB at 3.2 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/checkerframework/checker-qual/3.31.0/checker-qual-3.31.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/waffle/waffle-jna/1.9.1/waffle-jna-1.9.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/4.5.1/jna-4.5.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/4.5.1/jna-platform-4.5.1.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/jcl-over-slf4j/1.7.25/jcl-over-slf4j-1.7.25.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/jcl-over-slf4j/1.7.25/jcl-over-slf4j-1.7.25.jar (17 kB at 199 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/waffle/waffle-jna/1.9.1/waffle-jna-1.9.1.jar (68 kB at 650 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/github/ben-manes/caffeine/caffeine/2.6.2/caffeine-2.6.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/checkerframework/checker-qual/3.31.0/checker-qual-3.31.0.jar (224 kB at 2.1 MB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar (41 kB at 197 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/github/ben-manes/caffeine/caffeine/2.6.2/caffeine-2.6.2.jar (660 kB at 2.2 MB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/4.5.1/jna-4.5.1.jar (1.4 MB at 1.9 MB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/4.5.1/jna-platform-4.5.1.jar (2.3 MB at 1.7 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-test/3.2.3/spring-boot-starter-test-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-test/3.2.3/spring-boot-starter-test-3.2.3.pom (5.0 kB at 112 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test/3.2.3/spring-boot-test-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test/3.2.3/spring-boot-test-3.2.3.pom (2.0 kB at 34 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test-autoconfigure/3.2.3/spring-boot-test-autoconfigure-3.2.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test-autoconfigure/3.2.3/spring-boot-test-autoconfigure-3.2.3.pom (2.5 kB at 55 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/jayway/jsonpath/json-path/2.9.0/json-path-2.9.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/jayway/jsonpath/json-path/2.9.0/json-path-2.9.0.pom (1.9 kB at 43 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/minidev/json-smart/2.5.0/json-smart-2.5.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/minidev/json-smart/2.5.0/json-smart-2.5.0.pom (9.2 kB at 200 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/minidev/accessors-smart/2.5.0/accessors-smart-2.5.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/minidev/accessors-smart/2.5.0/accessors-smart-2.5.0.pom (11 kB at 222 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.3/asm-9.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.3/asm-9.3.pom (2.4 kB at 53 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/ow2/1.5/ow2-1.5.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/ow2/1.5/ow2-1.5.pom (11 kB at 234 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.11/slf4j-api-2.0.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.11/slf4j-api-2.0.11.pom (2.8 kB at 58 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.11/slf4j-parent-2.0.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/2.0.11/slf4j-parent-2.0.11.pom (15 kB at 302 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-bom/2.0.11/slf4j-bom-2.0.11.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-bom/2.0.11/slf4j-bom-2.0.11.pom (7.3 kB at 163 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.1/jakarta.xml.bind-api-4.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.1/jakarta.xml.bind-api-4.0.1.pom (13 kB at 265 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api-parent/4.0.1/jakarta.xml.bind-api-parent-4.0.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api-parent/4.0.1/jakarta.xml.bind-api-parent-4.0.1.pom (9.2 kB at 199 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.2/jakarta.activation-api-2.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.2/jakarta.activation-api-2.1.2.pom (18 kB at 368 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-core/3.24.2/assertj-core-3.24.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-core/3.24.2/assertj-core-3.24.2.pom (19 kB at 401 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-parent/3.24.2/assertj-parent-3.24.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-parent/3.24.2/assertj-parent-3.24.2.pom (13 kB at 263 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-build/3.24.2/assertj-build-3.24.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-build/3.24.2/assertj-build-3.24.2.pom (8.8 kB at 179 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.12.21/byte-buddy-1.12.21.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.12.21/byte-buddy-1.12.21.pom (16 kB at 299 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.12.21/byte-buddy-parent-1.12.21.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.12.21/byte-buddy-parent-1.12.21.pom (58 kB at 957 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/awaitility/awaitility/4.2.0/awaitility-4.2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/awaitility/awaitility/4.2.0/awaitility-4.2.0.pom (3.5 kB at 77 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/awaitility/awaitility-parent/4.2.0/awaitility-parent-4.2.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/awaitility/awaitility-parent/4.2.0/awaitility-parent-4.2.0.pom (10 kB at 209 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest/2.1/hamcrest-2.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest/2.1/hamcrest-2.1.pom (1.1 kB at 25 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest/2.2/hamcrest-2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest/2.2/hamcrest-2.2.pom (1.1 kB at 26 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter/5.10.2/junit-jupiter-5.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter/5.10.2/junit-jupiter-5.10.2.pom (3.2 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.2/junit-jupiter-api-5.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.2/junit-jupiter-api-5.10.2.pom (3.2 kB at 69 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.pom (2.0 kB at 45 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-commons/1.10.2/junit-platform-commons-1.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-commons/1.10.2/junit-platform-commons-1.10.2.pom (2.8 kB at 59 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apiguardian/apiguardian-api/1.1.2/apiguardian-api-1.1.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apiguardian/apiguardian-api/1.1.2/apiguardian-api-1.1.2.pom (1.5 kB at 32 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-params/5.10.2/junit-jupiter-params-5.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-params/5.10.2/junit-jupiter-params-5.10.2.pom (3.0 kB at 63 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.10.2/junit-jupiter-engine-5.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.10.2/junit-jupiter-engine-5.10.2.pom (3.2 kB at 70 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-engine/1.10.2/junit-platform-engine-1.10.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-engine/1.10.2/junit-platform-engine-1.10.2.pom (3.2 kB at 70 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-core/5.7.0/mockito-core-5.7.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-core/5.7.0/mockito-core-5.7.0.pom (2.5 kB at 54 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.9/byte-buddy-1.14.9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.9/byte-buddy-1.14.9.pom (16 kB at 247 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.14.9/byte-buddy-parent-1.14.9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.14.9/byte-buddy-parent-1.14.9.pom (62 kB at 880 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.9/byte-buddy-agent-1.14.9.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.9/byte-buddy-agent-1.14.9.pom (10 kB at 205 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/objenesis/objenesis/3.3/objenesis-3.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/objenesis/objenesis/3.3/objenesis-3.3.pom (3.0 kB at 65 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/objenesis/objenesis-parent/3.3/objenesis-parent-3.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/objenesis/objenesis-parent/3.3/objenesis-parent-3.3.pom (19 kB at 355 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-junit-jupiter/5.7.0/mockito-junit-jupiter-5.7.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-junit-jupiter/5.7.0/mockito-junit-jupiter-5.7.0.pom (2.3 kB at 47 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.0/junit-jupiter-api-5.10.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.0/junit-jupiter-api-5.10.0.pom (3.2 kB at 68 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-commons/1.10.0/junit-platform-commons-1.10.0.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-commons/1.10.0/junit-platform-commons-1.10.0.pom (2.8 kB at 59 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/skyscreamer/jsonassert/1.5.1/jsonassert-1.5.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/skyscreamer/jsonassert/1.5.1/jsonassert-1.5.1.pom (5.2 kB at 110 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vaadin/external/google/android-json/0.0.20131108.vaadin1/android-json-0.0.20131108.vaadin1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vaadin/external/google/android-json/0.0.20131108.vaadin1/android-json-0.0.20131108.vaadin1.pom (2.8 kB at 61 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-test/6.1.4/spring-test-6.1.4.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-test/6.1.4/spring-test-6.1.4.pom (2.0 kB at 42 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/xmlunit/xmlunit-core/2.9.1/xmlunit-core-2.9.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/xmlunit/xmlunit-core/2.9.1/xmlunit-core-2.9.1.pom (2.4 kB at 54 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/xmlunit/xmlunit-parent/2.9.1/xmlunit-parent-2.9.1.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/xmlunit/xmlunit-parent/2.9.1/xmlunit-parent-2.9.1.pom (21 kB at 433 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/2.3.3/jakarta.xml.bind-api-2.3.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/2.3.3/jakarta.xml.bind-api-2.3.3.pom (13 kB at 285 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api-parent/2.3.3/jakarta.xml.bind-api-parent-2.3.3.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api-parent/2.3.3/jakarta.xml.bind-api-parent-2.3.3.pom (9.0 kB at 195 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/1.2.2/jakarta.activation-api-1.2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/1.2.2/jakarta.activation-api-1.2.2.pom (5.3 kB at 118 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/sun/activation/all/1.2.2/all-1.2.2.pom
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/activation/all/1.2.2/all-1.2.2.pom (15 kB at 323 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-test/3.2.3/spring-boot-starter-test-3.2.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-test/3.2.3/spring-boot-starter-test-3.2.3.jar (4.8 kB at 106 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test/3.2.3/spring-boot-test-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test-autoconfigure/3.2.3/spring-boot-test-autoconfigure-3.2.3.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/jayway/jsonpath/json-path/2.9.0/json-path-2.9.0.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.11/slf4j-api-2.0.11.jar
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.1/jakarta.xml.bind-api-4.0.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.11/slf4j-api-2.0.11.jar (68 kB at 421 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.2/jakarta.activation-api-2.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/xml/bind/jakarta.xml.bind-api/4.0.1/jakarta.xml.bind-api-4.0.1.jar (130 kB at 730 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/minidev/json-smart/2.5.0/json-smart-2.5.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/jayway/jsonpath/json-path/2.9.0/json-path-2.9.0.jar (277 kB at 1.3 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/minidev/accessors-smart/2.5.0/accessors-smart-2.5.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test/3.2.3/spring-boot-test-3.2.3.jar (246 kB at 1.1 MB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.3/asm-9.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-test-autoconfigure/3.2.3/spring-boot-test-autoconfigure-3.2.3.jar (219 kB at 970 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-core/3.24.2/assertj-core-3.24.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/jakarta/activation/jakarta.activation-api/2.1.2/jakarta.activation-api-2.1.2.jar (66 kB at 264 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.12.21/byte-buddy-1.12.21.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/minidev/accessors-smart/2.5.0/accessors-smart-2.5.0.jar (30 kB at 115 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/awaitility/awaitility/4.2.0/awaitility-4.2.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/minidev/json-smart/2.5.0/json-smart-2.5.0.jar (120 kB at 416 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest/2.2/hamcrest-2.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/ow2/asm/asm/9.3/asm-9.3.jar (122 kB at 296 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter/5.10.2/junit-jupiter-5.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/awaitility/awaitility/4.2.0/awaitility-4.2.0.jar (96 kB at 228 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.2/junit-jupiter-api-5.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/hamcrest/hamcrest/2.2/hamcrest-2.2.jar (123 kB at 273 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter/5.10.2/junit-jupiter-5.10.2.jar (6.4 kB at 11 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-commons/1.10.2/junit-platform-commons-1.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.2/junit-jupiter-api-5.10.2.jar (211 kB at 345 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/apiguardian/apiguardian-api/1.1.2/apiguardian-api-1.1.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.jar (14 kB at 23 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-params/5.10.2/junit-jupiter-params-5.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-commons/1.10.2/junit-platform-commons-1.10.2.jar (106 kB at 141 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.10.2/junit-jupiter-engine-5.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/apiguardian/apiguardian-api/1.1.2/apiguardian-api-1.1.2.jar (6.8 kB at 9.0 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-engine/1.10.2/junit-platform-engine-1.10.2.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/platform/junit-platform-engine/1.10.2/junit-platform-engine-1.10.2.jar (205 kB at 130 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-core/5.7.0/mockito-core-5.7.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.10.2/junit-jupiter-engine-5.10.2.jar (245 kB at 76 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.9/byte-buddy-agent-1.14.9.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/assertj/assertj-core/3.24.2/assertj-core-3.24.2.jar (1.3 MB at 401 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/objenesis/objenesis/3.3/objenesis-3.3.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-core/5.7.0/mockito-core-5.7.0.jar (700 kB at 207 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-junit-jupiter/5.7.0/mockito-junit-jupiter-5.7.0.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/junit/jupiter/junit-jupiter-params/5.10.2/junit-jupiter-params-5.10.2.jar (586 kB at 164 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/skyscreamer/jsonassert/1.5.1/jsonassert-1.5.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/mockito/mockito-junit-jupiter/5.7.0/mockito-junit-jupiter-5.7.0.jar (8.8 kB at 2.4 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/com/vaadin/external/google/android-json/0.0.20131108.vaadin1/android-json-0.0.20131108.vaadin1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/objenesis/objenesis/3.3/objenesis-3.3.jar (49 kB at 13 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/spring-test/6.1.4/spring-test-6.1.4.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/com/vaadin/external/google/android-json/0.0.20131108.vaadin1/android-json-0.0.20131108.vaadin1.jar (18 kB at 4.5 kB/s)
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/xmlunit/xmlunit-core/2.9.1/xmlunit-core-2.9.1.jar
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/skyscreamer/jsonassert/1.5.1/jsonassert-1.5.1.jar (31 kB at 7.5 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/xmlunit/xmlunit-core/2.9.1/xmlunit-core-2.9.1.jar (175 kB at 37 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.9/byte-buddy-agent-1.14.9.jar (257 kB at 54 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.12.21/byte-buddy-1.12.21.jar (3.9 MB at 729 kB/s)
[INFO] Downloaded from central: https://repo.maven.apache.org/maven2/org/springframework/spring-test/6.1.4/spring-test-6.1.4.jar (854 kB at 152 kB/s)
[INFO] Resolved plugin: jetty-servlet-9.4.46.v20220331.jar
[INFO] Resolved plugin: maven-compiler-plugin-3.11.0.jar
[INFO] Resolved plugin: doxia-module-twiki-1.11.1.jar
[INFO] Resolved plugin: jdependency-2.8.0.jar
[INFO] Resolved plugin: maven-deploy-plugin-3.1.1.jar
[INFO] Resolved plugin: velocity-tools-2.0.jar
[INFO] Resolved plugin: spring-boot-maven-plugin-3.2.3.jar
[INFO] Resolved plugin: flexmark-ext-gfm-tasklist-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-admonition-0.42.14.jar
[INFO] Resolved plugin: jna-5.13.0.jar
[INFO] Resolved plugin: maven-core-3.2.5.jar
[INFO] Resolved plugin: flexmark-ext-footnotes-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-gfm-strikethrough-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-media-tags-0.42.14.jar
[INFO] Resolved plugin: doxia-module-xhtml-1.11.1.jar
[INFO] Resolved plugin: flexmark-util-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-anchorlink-0.42.14.jar
[INFO] Resolved plugin: aether-api-1.0.0.v20140518.jar
[INFO] Resolved plugin: autolink-0.6.0.jar
[INFO] Resolved plugin: maven-filtering-3.3.1.jar
[INFO] Resolved plugin: maven-clean-plugin-3.3.2.jar
[INFO] Resolved plugin: doxia-skin-model-1.11.1.jar
[INFO] Resolved plugin: dom4j-1.1.jar
[INFO] Resolved plugin: flexmark-youtrack-converter-0.42.14.jar
[INFO] Resolved plugin: maven-jar-plugin-3.3.0.jar
[INFO] Resolved plugin: tomlj-1.0.0.jar
[INFO] Resolved plugin: httpclient-4.5.13.jar
[INFO] Resolved plugin: flexmark-ext-toc-0.42.14.jar
[INFO] Resolved plugin: qdox-2.0.3.jar
[INFO] Resolved plugin: plexus-compiler-manager-2.13.0.jar
[INFO] Resolved plugin: micrometer-commons-1.12.3.jar
[INFO] Resolved plugin: jetty-http-9.4.46.v20220331.jar
[INFO] Resolved plugin: flexmark-jira-converter-0.42.14.jar
[INFO] Resolved plugin: maven-reporting-api-3.1.1.jar
[INFO] Resolved plugin: maven-plugin-api-3.2.5.jar
[INFO] Resolved plugin: sisu-guice-3.2.3-no_aop.jar
[INFO] Resolved plugin: flexmark-ext-attributes-0.42.14.jar
[INFO] Resolved plugin: commons-lang3-3.8.1.jar
[INFO] Resolved plugin: maven-aether-provider-3.2.5.jar
[INFO] Resolved plugin: aether-util-1.0.0.v20140518.jar
[INFO] Resolved plugin: jetty-security-9.4.46.v20220331.jar
[INFO] Resolved plugin: maven-archiver-3.6.0.jar
[INFO] Resolved plugin: commons-io-2.12.0.jar
[INFO] Resolved plugin: plexus-compiler-api-2.13.0.jar
[INFO] Resolved plugin: org.eclipse.sisu.plexus-0.3.5.jar
[INFO] Resolved plugin: doxia-core-1.11.1.jar
[INFO] Resolved plugin: flexmark-ext-ins-0.42.14.jar
[INFO] Resolved plugin: surefire-shared-utils-3.1.2.jar
[INFO] Resolved plugin: maven-install-plugin-3.1.1.jar
[INFO] Resolved plugin: google-collections-1.0.jar
[INFO] Resolved plugin: plexus-java-1.1.2.jar
[INFO] Resolved plugin: flexmark-ext-emoji-0.42.14.jar
[INFO] Resolved plugin: doxia-integration-tools-1.11.1.jar
[INFO] Resolved plugin: httpcore5-5.2.4.jar
[INFO] Resolved plugin: plexus-component-annotations-1.5.5.jar
[INFO] Resolved plugin: maven-repository-metadata-3.2.5.jar
[INFO] Resolved plugin: surefire-api-3.1.2.jar
[INFO] Resolved plugin: flexmark-ext-jekyll-front-matter-0.42.14.jar
[INFO] Resolved plugin: doxia-decoration-model-1.11.1.jar
[INFO] Resolved plugin: flexmark-all-0.42.14.jar
[INFO] Resolved plugin: plexus-utils-3.5.0.jar
[INFO] Resolved plugin: maven-shared-incremental-1.1.jar
[INFO] Resolved plugin: file-management-3.1.0.jar
[INFO] Resolved plugin: plexus-archiver-4.4.0.jar
[INFO] Resolved plugin: jetty-webapp-9.4.46.v20220331.jar
[INFO] Resolved plugin: plexus-io-3.2.0.jar
[INFO] Resolved plugin: xbean-reflect-3.7.jar
[INFO] Resolved plugin: maven-reporting-exec-1.6.0.jar
[INFO] Resolved plugin: doxia-sink-api-1.11.1.jar
[INFO] Resolved plugin: jetty-xml-9.4.46.v20220331.jar
[INFO] Resolved plugin: plexus-velocity-1.2.jar
[INFO] Resolved plugin: plexus-container-default-2.1.0.jar
[INFO] Resolved plugin: commons-codec-1.11.jar
[INFO] Resolved plugin: surefire-logger-api-3.1.2.jar
[INFO] Resolved plugin: snappy-0.4.jar
[INFO] Resolved plugin: maven-surefire-plugin-3.1.2.jar
[INFO] Resolved plugin: jsr305-3.0.2.jar
[INFO] Resolved plugin: plexus-compiler-javac-2.13.0.jar
[INFO] Resolved plugin: plexus-build-api-0.0.7.jar
[INFO] Resolved plugin: doxia-module-fml-1.11.1.jar
[INFO] Resolved plugin: commons-compress-1.21.jar
[INFO] Resolved plugin: asm-9.5.jar
[INFO] Resolved plugin: maven-dependency-tree-3.2.1.jar
[INFO] Resolved plugin: commons-digester-1.8.jar
[INFO] Resolved plugin: jetty-server-9.4.46.v20220331.jar
[INFO] Resolved plugin: flexmark-ext-abbreviation-0.42.14.jar
[INFO] Resolved plugin: maven-archiver-3.5.2.jar
[INFO] Resolved plugin: httpcore5-h2-5.2.4.jar
[INFO] Resolved plugin: flexmark-ext-definition-0.42.14.jar
[INFO] Resolved plugin: doxia-logging-api-1.11.1.jar
[INFO] Resolved plugin: spring-boot-loader-tools-3.2.3.jar
[INFO] Resolved plugin: flexmark-ext-yaml-front-matter-0.42.14.jar
[INFO] Resolved plugin: maven-site-plugin-3.12.1.jar
[INFO] Resolved plugin: maven-shade-plugin-3.5.0.jar
[INFO] Resolved plugin: flexmark-ext-superscript-0.42.14.jar
[INFO] Resolved plugin: commons-collections-3.2.2.jar
[INFO] Resolved plugin: surefire-extensions-spi-3.1.2.jar
[INFO] Resolved plugin: doxia-module-markdown-1.11.1.jar
[INFO] Resolved plugin: flexmark-ext-xwiki-macros-0.42.14.jar
[INFO] Resolved plugin: commons-compress-1.20.jar
[INFO] Resolved plugin: plexus-io-3.4.0.jar
[INFO] Resolved plugin: asm-9.4.jar
[INFO] Resolved plugin: maven-resources-plugin-3.3.1.jar
[INFO] Resolved plugin: velocity-1.7.jar
[INFO] Resolved plugin: spring-jcl-6.0.10.jar
[INFO] Resolved plugin: plexus-utils-3.5.1.jar
[INFO] Resolved plugin: httpclient5-5.2.3.jar
[INFO] Resolved plugin: aopalliance-1.0.jar
[INFO] Resolved plugin: aether-spi-1.0.0.v20140518.jar
[INFO] Resolved plugin: plexus-interpolation-1.26.jar
[INFO] Resolved plugin: maven-settings-builder-3.2.5.jar
[INFO] Resolved plugin: httpcore-4.4.14.jar
[INFO] Resolved plugin: surefire-booter-3.1.2.jar
[INFO] Resolved plugin: commons-lang3-3.12.0.jar
[INFO] Resolved plugin: spring-boot-buildpack-platform-3.2.3.jar
[INFO] Resolved plugin: maven-artifact-3.2.5.jar
[INFO] Resolved plugin: flexmark-ext-enumerated-reference-0.42.14.jar
[INFO] Resolved plugin: spring-context-6.1.4.jar
[INFO] Resolved plugin: plexus-component-annotations-2.1.1.jar
[INFO] Resolved plugin: maven-surefire-common-3.1.2.jar
[INFO] Resolved plugin: commons-logging-1.2.jar
[INFO] Resolved plugin: flexmark-ext-escaped-character-0.42.14.jar
[INFO] Resolved plugin: jackson-annotations-2.14.2.jar
[INFO] Resolved plugin: plexus-cipher-1.4.jar
[INFO] Resolved plugin: flexmark-0.42.14.jar
[INFO] Resolved plugin: plexus-utils-3.4.2.jar
[INFO] Resolved plugin: flexmark-ext-aside-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-wikilink-0.42.14.jar
[INFO] Resolved plugin: org.eclipse.sisu.inject-0.3.5.jar
[INFO] Resolved plugin: flexmark-ext-gfm-tables-0.42.14.jar
[INFO] Resolved plugin: antlr4-runtime-4.7.2.jar
[INFO] Resolved plugin: commons-io-2.11.0.jar
[INFO] Resolved plugin: jetty-io-9.4.46.v20220331.jar
[INFO] Resolved plugin: cdi-api-1.2.jar
[INFO] Resolved plugin: commons-chain-1.1.jar
[INFO] Resolved plugin: plexus-utils-1.5.8.jar
[INFO] Resolved plugin: flexmark-html-parser-0.42.14.jar
[INFO] Resolved plugin: javax.inject-1.jar
[INFO] Resolved plugin: asm-tree-9.5.jar
[INFO] Resolved plugin: maven-shared-utils-3.3.4.jar
[INFO] Resolved plugin: javax.servlet-api-3.1.0.jar
[INFO] Resolved plugin: jetty-util-ajax-9.4.46.v20220331.jar
[INFO] Resolved plugin: spring-beans-6.1.4.jar
[INFO] Resolved plugin: commons-io-2.13.0.jar
[INFO] Resolved plugin: maven-settings-3.2.5.jar
[INFO] Resolved plugin: jna-platform-5.13.0.jar
[INFO] Resolved plugin: jackson-core-2.14.2.jar
[INFO] Resolved plugin: jsoup-1.10.2.jar
[INFO] Resolved plugin: oro-2.0.8.jar
[INFO] Resolved plugin: maven-common-artifact-filters-3.3.2.jar
[INFO] Resolved plugin: xz-1.9.jar
[INFO] Resolved plugin: spring-aop-6.1.4.jar
[INFO] Resolved plugin: aether-impl-1.0.0.v20140518.jar
[INFO] Resolved plugin: commons-text-1.3.jar
[INFO] Resolved plugin: plexus-utils-4.0.0.jar
[INFO] Resolved plugin: spring-core-6.0.10.jar
[INFO] Resolved plugin: commons-lang-2.4.jar
[INFO] Resolved plugin: slf4j-api-1.7.36.jar
[INFO] Resolved plugin: doxia-module-apt-1.11.1.jar
[INFO] Resolved plugin: flexmark-ext-gfm-issues-0.42.14.jar
[INFO] Resolved plugin: jetty-util-9.4.46.v20220331.jar
[INFO] Resolved plugin: spring-expression-6.1.4.jar
[INFO] Resolved plugin: maven-model-builder-3.2.5.jar
[INFO] Resolved plugin: plexus-archiver-4.2.7.jar
[INFO] Resolved plugin: jackson-databind-2.14.2.jar
[INFO] Resolved plugin: commons-io-2.6.jar
[INFO] Resolved plugin: flexmark-ext-youtube-embedded-0.42.14.jar
[INFO] Resolved plugin: flexmark-formatter-0.42.14.jar
[INFO] Resolved plugin: maven-model-3.2.5.jar
[INFO] Resolved plugin: surefire-extensions-api-3.1.2.jar
[INFO] Resolved plugin: jdom2-2.0.6.1.jar
[INFO] Resolved plugin: flexmark-profile-pegdown-0.42.14.jar
[INFO] Resolved plugin: doxia-module-docbook-simple-1.11.1.jar
[INFO] Resolved plugin: guava-16.0.1.jar
[INFO] Resolved plugin: plexus-interpolation-1.21.jar
[INFO] Resolved plugin: flexmark-ext-typographic-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-autolink-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-jekyll-tag-0.42.14.jar
[INFO] Resolved plugin: flexmark-ext-gitlab-0.42.14.jar
[INFO] Resolved plugin: doxia-module-xdoc-1.11.1.jar
[INFO] Resolved plugin: doxia-site-renderer-1.11.1.jar
[INFO] Resolved plugin: commons-beanutils-1.7.0.jar
[INFO] Resolved plugin: plexus-classworlds-2.5.2.jar
[INFO] Resolved plugin: doxia-module-confluence-1.11.1.jar
[INFO] Resolved plugin: doxia-module-xhtml5-1.11.1.jar
[INFO] Resolved plugin: flexmark-ext-tables-0.42.14.jar
[INFO] Resolved plugin: javax.annotation-api-1.2.jar
[INFO] Resolved plugin: flexmark-ext-macros-0.42.14.jar
[INFO] Resolved plugin: plexus-sec-dispatcher-1.3.jar
[INFO] Resolved plugin: micrometer-observation-1.12.3.jar
[INFO] Resolved plugin: jackson-module-parameter-names-2.14.2.jar
[INFO] Resolved plugin: commons-collections4-4.4.jar
[INFO] Resolved plugin: plexus-i18n-1.0-beta-10.jar
[INFO] Resolved plugin: flexmark-ext-gfm-users-0.42.14.jar
[INFO] Resolved plugin: maven-common-artifact-filters-3.1.1.jar
[INFO] Resolved plugin: asm-commons-9.5.jar
[INFO] Resolved dependency: tomcat-embed-websocket-10.1.19.jar
[INFO] Resolved dependency: jackson-core-2.15.4.jar
[INFO] Resolved dependency: spring-test-6.1.4.jar
[INFO] Resolved dependency: jackson-datatype-jdk8-2.15.4.jar
[INFO] Resolved dependency: spring-boot-starter-tomcat-3.2.3.jar
[INFO] Resolved dependency: postgresql-42.6.1.jar
[INFO] Resolved dependency: jaxb-core-4.0.2.jar
[INFO] Resolved dependency: spring-boot-test-3.2.3.jar
[INFO] Resolved dependency: log4j-to-slf4j-2.21.1.jar
[INFO] Resolved dependency: jackson-annotations-2.15.4.jar
[INFO] Resolved dependency: jakarta.xml.bind-api-4.0.1.jar
[INFO] Resolved dependency: jakarta.activation-api-2.1.0.jar
[INFO] Resolved dependency: spring-context-6.1.4.jar
[INFO] Resolved dependency: spring-data-jpa-3.2.3.jar
[INFO] Resolved dependency: spring-boot-starter-3.2.3.jar
[INFO] Resolved dependency: spring-boot-starter-aop-3.2.3.jar
[INFO] Resolved dependency: opentest4j-1.3.0.jar
[INFO] Resolved dependency: xmlunit-core-2.9.1.jar
[INFO] Resolved dependency: jakarta.transaction-api-2.0.1.jar
[INFO] Resolved dependency: junit-platform-commons-1.10.2.jar
[INFO] Resolved dependency: jna-4.5.1.jar
[INFO] Resolved dependency: angus-activation-2.0.0.jar
[INFO] Resolved dependency: HikariCP-5.0.1.jar
[INFO] Resolved dependency: snakeyaml-2.2.jar
[INFO] Resolved dependency: json-smart-2.5.0.jar
[INFO] Resolved dependency: mockito-core-5.7.0.jar
[INFO] Resolved dependency: mockito-junit-jupiter-5.7.0.jar
[INFO] Resolved dependency: micrometer-commons-1.12.3.jar
[INFO] Resolved dependency: spring-boot-test-autoconfigure-3.2.3.jar
[INFO] Resolved dependency: jakarta.activation-api-2.1.2.jar
[INFO] Resolved dependency: accessors-smart-2.5.0.jar
[INFO] Resolved dependency: checker-qual-3.31.0.jar
[INFO] Resolved dependency: assertj-core-3.24.2.jar
[INFO] Resolved dependency: jackson-datatype-jsr310-2.15.4.jar
[INFO] Resolved dependency: txw2-4.0.2.jar
[INFO] Resolved dependency: spring-core-6.1.4.jar
[INFO] Resolved dependency: waffle-jna-1.9.1.jar
[INFO] Resolved dependency: hamcrest-2.2.jar
[INFO] Resolved dependency: spring-boot-starter-data-jpa-3.2.3.jar
[INFO] Resolved dependency: spring-orm-6.1.4.jar
[INFO] Resolved dependency: istack-commons-runtime-4.1.1.jar
[INFO] Resolved dependency: spring-beans-6.1.4.jar
[INFO] Resolved dependency: jboss-logging-3.5.0.Final.jar
[INFO] Resolved dependency: jsonassert-1.5.1.jar
[INFO] Resolved dependency: awaitility-4.2.0.jar
[INFO] Resolved dependency: byte-buddy-agent-1.14.9.jar
[INFO] Resolved dependency: slf4j-api-2.0.11.jar
[INFO] Resolved dependency: log4j-api-2.21.1.jar
[INFO] Resolved dependency: classmate-1.5.1.jar
[INFO] Resolved dependency: jakarta.xml.bind-api-4.0.0.jar
[INFO] Resolved dependency: junit-jupiter-engine-5.10.2.jar
[INFO] Resolved dependency: spring-aop-6.1.4.jar
[INFO] Resolved dependency: spring-boot-autoconfigure-3.2.3.jar
[INFO] Resolved dependency: slf4j-api-2.0.2.jar
[INFO] Resolved dependency: spring-jcl-6.1.4.jar
[INFO] Resolved dependency: byte-buddy-1.12.21.jar
[INFO] Resolved dependency: objenesis-3.3.jar
[INFO] Resolved dependency: hibernate-commons-annotations-6.0.6.Final.jar
[INFO] Resolved dependency: antlr4-runtime-4.13.0.jar
[INFO] Resolved dependency: spring-expression-6.1.4.jar
[INFO] Resolved dependency: asm-9.3.jar
[INFO] Resolved dependency: junit-platform-engine-1.10.2.jar
[INFO] Resolved dependency: tomcat-embed-el-10.1.19.jar
[INFO] Resolved dependency: jul-to-slf4j-2.0.12.jar
[INFO] Resolved dependency: jcl-over-slf4j-1.7.25.jar
[INFO] Resolved dependency: spring-aspects-6.1.4.jar
[INFO] Resolved dependency: caffeine-2.6.2.jar
[INFO] Resolved dependency: jackson-databind-2.15.4.jar
[INFO] Resolved dependency: spring-jdbc-6.1.4.jar
[INFO] Resolved dependency: logback-classic-1.4.14.jar
[INFO] Resolved dependency: byte-buddy-1.14.11.jar
[INFO] Resolved dependency: jakarta.persistence-api-3.1.0.jar
[INFO] Resolved dependency: junit-jupiter-5.10.2.jar
[INFO] Resolved dependency: spring-boot-starter-jdbc-3.2.3.jar
[INFO] Resolved dependency: spring-boot-starter-logging-3.2.3.jar
[INFO] Resolved dependency: spring-data-commons-3.2.3.jar
[INFO] Resolved dependency: jackson-module-parameter-names-2.15.4.jar
[INFO] Resolved dependency: slf4j-api-2.0.7.jar
[INFO] Resolved dependency: spring-boot-starter-web-3.2.3.jar
[INFO] Resolved dependency: spring-tx-6.1.4.jar
[INFO] Resolved dependency: tomcat-embed-core-10.1.19.jar
[INFO] Resolved dependency: jakarta.annotation-api-2.1.1.jar
[INFO] Resolved dependency: jaxb-runtime-4.0.2.jar
[INFO] Resolved dependency: jakarta.inject-api-2.0.1.jar
[INFO] Resolved dependency: jakarta.annotation-api-2.0.0.jar
[INFO] Resolved dependency: junit-jupiter-api-5.10.2.jar
[INFO] Resolved dependency: jna-platform-4.5.1.jar
[INFO] Resolved dependency: logback-core-1.4.14.jar
[INFO] Resolved dependency: spring-boot-3.2.3.jar
[INFO] Resolved dependency: jandex-3.1.2.jar
[INFO] Resolved dependency: micrometer-observation-1.12.3.jar
[INFO] Resolved dependency: json-path-2.9.0.jar
[INFO] Resolved dependency: junit-jupiter-params-5.10.2.jar
[INFO] Resolved dependency: apiguardian-api-1.1.2.jar
[INFO] Resolved dependency: spring-boot-starter-json-3.2.3.jar
[INFO] Resolved dependency: aspectjweaver-1.9.21.jar
[INFO] Resolved dependency: slf4j-api-1.7.25.jar
[INFO] Resolved dependency: spring-web-6.1.4.jar
[INFO] Resolved dependency: hibernate-core-6.4.4.Final.jar
[INFO] Resolved dependency: spring-boot-starter-test-3.2.3.jar
[INFO] Resolved dependency: spring-webmvc-6.1.4.jar
[INFO] Resolved dependency: android-json-0.0.20131108.vaadin1.jar
[INFO] Resolved dependency: lombok-1.18.30.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:23 min
[INFO] Finished at: 2024-03-18T09:03:56Z
[INFO] ------------------------------------------------------------------------
Removing intermediate container 6b68072017df
 ---> 1bd8100a7802
Step 5/11 : COPY src ./src
 ---> 7560f71c4168
Step 6/11 : RUN mvn package -DskipTests
 ---> Running in e0872ca13c44
[INFO] Scanning for projects...
[INFO]
[INFO] -----------------------< com.workshop:workshop2 >-----------------------
[INFO] Building workshop2 0.0.1-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.3.Final/jboss-logging-3.5.3.Final.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.3.Final/jboss-logging-3.5.3.Final.pom (19 kB at 35 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/logging/logging-parent/1.0.1.Final/logging-parent-1.0.1.Final.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/logging/logging-parent/1.0.1.Final/logging-parent-1.0.1.Final.pom (6.0 kB at 108 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.6.0/classmate-1.6.0.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.6.0/classmate-1.6.0.pom (6.6 kB at 121 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/55/oss-parent-55.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/oss-parent/55/oss-parent-55.pom (24 kB at 352 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.12/byte-buddy-1.14.12.pom
Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.12/byte-buddy-1.14.12.pom (16 kB at 278 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.14.12/byte-buddy-parent-1.14.12.pom
Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-parent/1.14.12/byte-buddy-parent-1.14.12.pom (63 kB at 603 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.4/jaxb-runtime-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.4/jaxb-runtime-4.0.4.pom (11 kB at 169 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-runtime-parent/4.0.4/jaxb-runtime-parent-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-runtime-parent/4.0.4/jaxb-runtime-parent-4.0.4.pom (1.2 kB at 24 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-parent/4.0.4/jaxb-parent-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-parent/4.0.4/jaxb-parent-4.0.4.pom (35 kB at 486 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/jaxb-bom-ext/4.0.4/jaxb-bom-ext-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/jaxb-bom-ext/4.0.4/jaxb-bom-ext-4.0.4.pom (3.5 kB at 72 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.4/jaxb-core-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.4/jaxb-core-4.0.4.pom (3.7 kB at 73 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.1/angus-activation-2.0.1.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.1/angus-activation-2.0.1.pom (4.0 kB at 83 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation-project/2.0.1/angus-activation-project-2.0.1.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation-project/2.0.1/angus-activation-project-2.0.1.pom (20 kB at 322 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.4/txw2-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.4/txw2-4.0.4.pom (1.8 kB at 34 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-txw-parent/4.0.4/jaxb-txw-parent-4.0.4.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/xml/bind/mvn/jaxb-txw-parent/4.0.4/jaxb-txw-parent-4.0.4.pom (1.2 kB at 25 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.2/istack-commons-runtime-4.1.2.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.2/istack-commons-runtime-4.1.2.pom (1.6 kB at 32 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons/4.1.2/istack-commons-4.1.2.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons/4.1.2/istack-commons-4.1.2.pom (26 kB at 365 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.12/byte-buddy-agent-1.14.12.pom
Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.12/byte-buddy-agent-1.14.12.pom (10 kB at 177 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.3.Final/jboss-logging-3.5.3.Final.jar
Downloaded from central: https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging/3.5.3.Final/jboss-logging-3.5.3.Final.jar (59 kB at 779 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.6.0/classmate-1.6.0.jar
Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.12/byte-buddy-1.14.12.jar
Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.4/jaxb-runtime-4.0.4.jar
Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.4/jaxb-core-4.0.4.jar
Downloading from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.1/angus-activation-2.0.1.jar
Downloaded from central: https://repo.maven.apache.org/maven2/com/fasterxml/classmate/1.6.0/classmate-1.6.0.jar (69 kB at 830 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.4/txw2-4.0.4.jar
Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/txw2/4.0.4/txw2-4.0.4.jar (73 kB at 245 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.2/istack-commons-runtime-4.1.2.jar
Downloaded from central: https://repo.maven.apache.org/maven2/org/eclipse/angus/angus-activation/2.0.1/angus-activation-2.0.1.jar (27 kB at 91 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.jar
Downloaded from central: https://repo.maven.apache.org/maven2/com/sun/istack/istack-commons-runtime/4.1.2/istack-commons-runtime-4.1.2.jar (26 kB at 53 kB/s)
Downloading from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.12/byte-buddy-agent-1.14.12.jar
Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-core/4.0.4/jaxb-core-4.0.4.jar (139 kB at 235 kB/s)
Downloaded from central: https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.jar (68 kB at 116 kB/s)
Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.12/byte-buddy-agent-1.14.12.jar (257 kB at 180 kB/s)
Downloaded from central: https://repo.maven.apache.org/maven2/org/glassfish/jaxb/jaxb-runtime/4.0.4/jaxb-runtime-4.0.4.jar (920 kB at 453 kB/s)
Downloaded from central: https://repo.maven.apache.org/maven2/net/bytebuddy/byte-buddy/1.14.12/byte-buddy-1.14.12.jar (4.2 MB at 916 kB/s)
[INFO]
[INFO] --- resources:3.3.1:resources (default-resources) @ workshop2 ---
[INFO] Copying 1 resource from src/main/resources to target/classes
[INFO] Copying 0 resource from src/main/resources to target/classes
[INFO]
[INFO] --- compiler:3.11.0:compile (default-compile) @ workshop2 ---
[INFO] Changes detected - recompiling the module! :source
[INFO] Compiling 8 source files with javac [debug release 17] to target/classes
[INFO]
[INFO] --- resources:3.3.1:testResources (default-testResources) @ workshop2 ---
[INFO] skip non existing resourceDirectory /app/src/test/resources
[INFO]
[INFO] --- compiler:3.11.0:testCompile (default-testCompile) @ workshop2 ---
[INFO] No sources to compile
[INFO]
[INFO] --- surefire:3.1.2:test (default-test) @ workshop2 ---
[INFO] Tests are skipped.
[INFO]
[INFO] --- jar:3.3.0:jar (default-jar) @ workshop2 ---
[INFO] Building jar: /app/target/workshop2-0.0.1-SNAPSHOT.jar
[INFO]
[INFO] --- spring-boot:3.2.3:repackage (repackage) @ workshop2 ---
[INFO] Replacing main artifact /app/target/workshop2-0.0.1-SNAPSHOT.jar with repackaged archive, adding nested dependencies in BOOT-INF/.
[INFO] The original artifact has been renamed to /app/target/workshop2-0.0.1-SNAPSHOT.jar.original
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  10.952 s
[INFO] Finished at: 2024-03-18T09:04:13Z
[INFO] ------------------------------------------------------------------------
Removing intermediate container e0872ca13c44
 ---> c21e9cc9a401
Step 7/11 : FROM openjdk:17-alpine
17-alpine: Pulling from library/openjdk
5843afab3874: Pull complete
53c9466125e4: Pull complete
d8d715783b80: Pull complete
Digest: sha256:4b6abae565492dbe9e7a894137c966a7485154238902f2f25e9dbd9784383d81
Status: Downloaded newer image for openjdk:17-alpine
 ---> 264c9bdce361
Step 8/11 : WORKDIR /app
 ---> Running in 10ad958edca7
Removing intermediate container 10ad958edca7
 ---> 647889d1dac0
Step 9/11 : COPY --from=builder /app/target/*.jar ./app.jar
 ---> 98977bc63c18
Step 10/11 : EXPOSE 8080
 ---> Running in ccc56a4cbdbf
Removing intermediate container ccc56a4cbdbf
 ---> b50f36989370
Step 11/11 : CMD ["java", "-jar", "app.jar"]
 ---> Running in c5c2a13f57ac
Removing intermediate container c5c2a13f57ac
 ---> 1da6ccb43b3b
Successfully built 1da6ccb43b3b
Successfully tagged container-image:latest
  ubuntu@thachpham  ~/firtcloudjourney/workshop2  $ docker images --filter reference=$ecr_name
REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
container-image   latest    1da6ccb43b3b   54 seconds ago   371MB
  ubuntu@thachpham  ~/firtcloudjourney/workshop2  $ cd ../temp
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker tag $ecr_name:latest $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker image ls
REPOSITORY                                                          TAG                               IMAGE ID       CREATED         SIZE
container-image                                                     latest                            1da6ccb43b3b   2 minutes ago   371MB
aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image   latest                            1da6ccb43b3b   2 minutes ago   371MB
<none>                                                              <none>                            c21e9cc9a401   3 minutes ago   503MB
maven                                                               3.9.6-eclipse-temurin-17-alpine   05532906c77c   3 months ago    332MB
openjdk                                                             17-alpine                         264c9bdce361   2 years ago     326MB
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
Using default tag: latest
The push refers to repository [aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image]
7b6ef6cb2ad8: Pushed
cb0321f67a34: Pushed
34f7184834b2: Pushed
5836ece05bfd: Pushed
72e830a4dff5: Pushed
latest: digest: sha256:21c8e9428dd0ecc6d945ab63cfb1b63d2806d46e88dc3b9c97507765043d5eda size: 1369
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker pull $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name:latest
latest: Pulling from container-image
Digest: sha256:21c8e9428dd0ecc6d945ab63cfb1b63d2806d46e88dc3b9c97507765043d5eda
Status: Image is up to date for aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest
aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "===========network"
===========network
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ vpc_name=$project-vpc
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ vpc_cidr=10.1.0.0/16
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo vpc_name=$vpc_name
echo vpc_cidr=$vpc_cidr
vpc_name=workshop2-vpc
vpc_cidr=10.1.0.0/16
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ vpc_id=$(aws ec2 create-vpc \
    --cidr-block $vpc_cidr \
    --region $region \
    --tag-specifications `echo 'ResourceType=vpc,Tags=[{Key=Name,Value='$vpc_name'},'$tagspec` \
    --output text \
    --query 'Vpc.VpcId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 modify-vpc-attribute \
    --vpc-id $vpc_id \
    --enable-dns-hostnames '{"Value": true}'
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo vpc_id=$vpc_id
vpc_id=vpc-083f047268c20e7f3
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ pubsubnet1_name=$project-pubsubnet-$az_01
pubsubnet2_name=$project-pubsubnet-$az_02
pubsubnet3_name=$project-pubsubnet-$az_03
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ for (( i=1; i<=3; i++ ))
do
    eval pubsubnet${i}_cidr=\"10.1.$((($i-1)*16)).0/20\"
done
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo pubsubnet1_name=$pubsubnet1_name
echo pubsubnet2_name=$pubsubnet2_name
echo pubsubnet3_name=$pubsubnet3_name
echo pubsubnet1_cidr=$pubsubnet1_cidr
echo pubsubnet2_cidr=$pubsubnet2_cidr
echo pubsubnet3_cidr=$pubsubnet3_cidr
pubsubnet1_name=workshop2-pubsubnet-ap-southeast-1a
pubsubnet2_name=workshop2-pubsubnet-ap-southeast-1b
pubsubnet3_name=workshop2-pubsubnet-ap-southeast-1c
pubsubnet1_cidr=10.1.0.0/20
pubsubnet2_cidr=10.1.16.0/20
pubsubnet3_cidr=10.1.32.0/20
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ subnet_public_1=$(aws ec2 create-subnet \
    --availability-zone $az_01 \
    --cidr-block $pubsubnet1_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet1_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ subnet_public_2=$(aws ec2 create-subnet \
    --availability-zone $az_02 \
    --cidr-block $pubsubnet2_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet2_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ subnet_public_3=$(aws ec2 create-subnet \
    --availability-zone $az_03 \
    --cidr-block $pubsubnet3_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet3_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo subnet_public_1=$subnet_public_1
echo subnet_public_2=$subnet_public_2
echo subnet_public_3=$subnet_public_3
subnet_public_1=subnet-0166cf1c9a99f7726
subnet_public_2=subnet-01a1f1f7237ab5feb
subnet_public_3=subnet-07b8a22f1377b36cb
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ prisubnet1_name=$project-prisubnet-$az_01
prisubnet2_name=$project-prisubnet-$az_02
prisubnet3_name=$project-prisubnet-$az_03
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ for (( i=1; i<=3; i++ ))
do
    eval prisubnet${i}_cidr=\"10.1.$((($i+3)*16)).0/20\"
done
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo prisubnet1_name=$prisubnet1_name
echo prisubnet2_name=$prisubnet2_name
echo prisubnet3_name=$prisubnet3_name
echo prisubnet1_cidr=$prisubnet1_cidr
echo prisubnet2_cidr=$prisubnet2_cidr
echo prisubnet3_cidr=$prisubnet3_cidr
prisubnet1_name=workshop2-prisubnet-ap-southeast-1a
prisubnet2_name=workshop2-prisubnet-ap-southeast-1b
prisubnet3_name=workshop2-prisubnet-ap-southeast-1c
prisubnet1_cidr=10.1.64.0/20
prisubnet2_cidr=10.1.80.0/20
prisubnet3_cidr=10.1.96.0/20
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ subnet_private_1=$(aws ec2 create-subnet \
    --availability-zone $az_01 \
    --cidr-block $prisubnet1_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet1_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

subnet_private_2=$(aws ec2 create-subnet \
    --availability-zone $az_02 \
    --cidr-block $prisubnet2_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet2_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

subnet_private_3=$(aws ec2 create-subnet \
    --availability-zone $az_03 \
    --cidr-block $prisubnet3_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet3_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo subnet_private_1=$subnet_private_1
echo subnet_private_2=$subnet_private_2
echo subnet_private_3=$subnet_private_3
subnet_private_1=subnet-06cbe85c62298e4c4
subnet_private_2=subnet-0feb0bce83a36e8a7
subnet_private_3=subnet-07b419dc161aa40b4
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ igw_name=$project-igw
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo igw_name=$igw_name
igw_name=workshop2-igw
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ gateway_id=$(aws ec2 create-internet-gateway \
    --region $region \
    --tag-specifications `echo 'ResourceType=internet-gateway,Tags=[{Key=Name,Value='$igw_name'},'$tagspec` \
    --output text \
    --query 'InternetGateway.InternetGatewayId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 attach-internet-gateway \
    --vpc-id $vpc_id \
    --internet-gateway-id $gateway_id
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo gateway_id=$gateway_id
gateway_id=igw-0dc65a47b72761f0c
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rtb_public_name=$project-rtb
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rtb_public_name=$rtb_public_name
rtb_public_name=workshop2-rtb
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rtb_public_id=$(aws ec2 create-route-table \
    --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_public_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-route \
    --route-table-id $rtb_public_id \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $gateway_id
{
    "Return": true
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 associate-route-table \
    --subnet-id $subnet_public_1 \
    --route-table-id $rtb_public_id

aws ec2 associate-route-table \
    --subnet-id $subnet_public_2 \
    --route-table-id $rtb_public_id

aws ec2 associate-route-table \
    --subnet-id $subnet_public_3 \
    --route-table-id $rtb_public_id
{
    "AssociationId": "rtbassoc-07c58f819b5c00154",
    "AssociationState": {
        "State": "associated"
    }
}
{
    "AssociationId": "rtbassoc-0c2ea7fbb7d017dc0",
    "AssociationState": {
        "State": "associated"
    }
}
{
    "AssociationId": "rtbassoc-0f91dcbec6fcf925d",
    "AssociationState": {
        "State": "associated"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rtb_public_id=$rtb_public_id
rtb_public_id=rtb-0a7e0250ed07ba9cf
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rtb_private_name=$project-rtb-private
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rtb_private_name=$rtb_private_name
rtb_private_name=workshop2-rtb-private
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rtb_private_id=$(aws ec2 create-route-table \
    --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_private_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 associate-route-table \
    --subnet-id $subnet_private_1 \
    --route-table-id $rtb_private_id

aws ec2 associate-route-table \
    --subnet-id $subnet_private_2 \
    --route-table-id $rtb_private_id

aws ec2 associate-route-table \
    --subnet-id $subnet_private_3 \
    --route-table-id $rtb_private_id
{
    "AssociationId": "rtbassoc-0945a842c41a7c46b",
    "AssociationState": {
        "State": "associated"
    }
}
{
    "AssociationId": "rtbassoc-02250897e6a5c9ef8",
    "AssociationState": {
        "State": "associated"
    }
}
{
    "AssociationId": "rtbassoc-0cd3a988e2c4b010d",
    "AssociationState": {
        "State": "associated"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rtb_private_id=$rtb_private_id
rtb_private_id=rtb-0d38e86b97503bcde
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "============== security group"
============== security group
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_sgr_name=$project-ecs-sgr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_sgr_name=$ecs_instance_sgr_name
ecs_instance_sgr_name=workshop2-ecs-sgr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_sgr_id=$(aws ec2 create-security-group \
    --group-name $ecs_instance_sgr_name \
    --description "Security group for EC2 in ECS" \
    --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$ecs_instance_sgr_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.GroupId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 authorize-security-group-ingress \
   --group-id $ecs_instance_sgr_id \
   --protocol tcp \
   --port 8080 \
   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-058dae9b6afdf466b",
            "GroupId": "sg-032aa58bc7026031c",
            "GroupOwnerId": "aws_account_id",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 8080,
            "ToPort": 8080,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 authorize-security-group-ingress \
   --group-id $ecs_instance_sgr_id \
   --protocol tcp \
   --port 22 \
   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0c62f35b809266133",
            "GroupId": "sg-032aa58bc7026031c",
            "GroupOwnerId": "aws_account_id",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 authorize-security-group-ingress \
   --group-id $ecs_instance_sgr_id \
   --protocol tcp \
   --port 443 \
   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0530237be2352964b",
            "GroupId": "sg-032aa58bc7026031c",
            "GroupOwnerId": "aws_account_id",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 443,
            "ToPort": 443,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_sgr_id=$ecs_instance_sgr_id
ecs_instance_sgr_id=sg-032aa58bc7026031c
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rds_sgr_name=$project-rds-sgr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rds_sgr_name=$rds_sgr_name
rds_sgr_name=workshop2-rds-sgr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rds_sgr_id=$(aws ec2 create-security-group \
    --group-name $rds_sgr_name  \
    --description "Security group for RDS" \
    --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$rds_sgr_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.GroupId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 authorize-security-group-ingress \
    --group-id $rds_sgr_id \
    --protocol tcp \
    --port 5432 \
     --source-group $ecs_instance_sgr_id
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-05e09b4abe671409e",
            "GroupId": "sg-0d540c37aac8736b6",
            "GroupOwnerId": "aws_account_id",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 5432,
            "ToPort": 5432,
            "ReferencedGroupInfo": {
                "GroupId": "sg-032aa58bc7026031c",
                "UserId": "aws_account_id"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rds_sgr_id=$rds_sgr_id
rds_sgr_id=sg-0d540c37aac8736b6
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ alb_sgr_name=$project-alb-sgr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo alb_sgr_name=$alb_sgr_name
alb_sgr_name=workshop2-alb-sgr
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo vpc_id=$vpc_id
vpc_id=vpc-083f047268c20e7f3
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ alb_sgr_id=$(aws ec2 create-security-group \
    --group-name $alb_sgr_name \
    --description "Security group for ALB" \
    --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$alb_sgr_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.GroupId')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 authorize-security-group-ingress \
   --group-id $alb_sgr_id \
   --protocol tcp \
   --port 22 \
   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0b1d544c709d14a36",
            "GroupId": "sg-0dcd139488f320ae2",
            "GroupOwnerId": "aws_account_id",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 authorize-security-group-ingress \
   --group-id $alb_sgr_id \
   --protocol tcp \
   --port 80 \
   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-064076ab829631b9d",
            "GroupId": "sg-0dcd139488f320ae2",
            "GroupOwnerId": "aws_account_id",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo alb_sgr_id=$alb_sgr_id
alb_sgr_id=sg-0dcd139488f320ae2
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "============= RDS"
============= RDS
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rds_subnet_group_name=$project-subnet-group
rds_subnet_group_descript="Subnet Group for Postgres RDS"
rds_subnet1_id=$subnet_private_1
rds_subnet2_id=$subnet_private_2
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rds_subnet_group_name=$rds_subnet_group_name
echo rds_subnet_group_descript=$rds_subnet_group_descript
echo rds_subnet1_id=$rds_subnet1_id
echo rds_subnet2_id=$rds_subnet2_id
rds_subnet_group_name=workshop2-subnet-group
rds_subnet_group_descript=Subnet Group for Postgres RDS
rds_subnet1_id=subnet-06cbe85c62298e4c4
rds_subnet2_id=subnet-0feb0bce83a36e8a7
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws rds create-db-subnet-group \
    --db-subnet-group-name $rds_subnet_group_name \
    --db-subnet-group-description "$rds_subnet_group_descript" \
    --subnet-ids $rds_subnet1_id $rds_subnet2_id \
    --tags "$tags"
{
    "DBSubnetGroup": {
        "DBSubnetGroupName": "workshop2-subnet-group",
        "DBSubnetGroupDescription": "Subnet Group for Postgres RDS",
        "VpcId": "vpc-083f047268c20e7f3",
        "SubnetGroupStatus": "Complete",
        "Subnets": [
            {
                "SubnetIdentifier": "subnet-0feb0bce83a36e8a7",
                "SubnetAvailabilityZone": {
                    "Name": "ap-southeast-1b"
                },
                "SubnetOutpost": {},
                "SubnetStatus": "Active"
            },
            {
                "SubnetIdentifier": "subnet-06cbe85c62298e4c4",
                "SubnetAvailabilityZone": {
                    "Name": "ap-southeast-1a"
                },
                "SubnetOutpost": {},
                "SubnetStatus": "Active"
            }
        ],
        "DBSubnetGroupArn": "arn:aws:rds:ap-southeast-1:aws_account_id:subgrp:workshop2-subnet-group",
        "SupportedNetworkTypes": [
            "IPV4"
        ]
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rds_name=$project-rds
rds_db_name="workshop"
rds_db_username="postgres"
rds_db_password="postgres"
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rds_name=$rds_name
echo rds_db_name=$rds_db_name
echo rds_db_username=$rds_db_username
echo rds_db_password=$rds_db_password
echo az_01=$az_01
echo rds_subnet_group_name=$rds_subnet_group_name
echo rds_sgr_id=$rds_sgr_id
rds_name=workshop2-rds
rds_db_name=workshop
rds_db_username=postgres
rds_db_password=postgres
az_01=ap-southeast-1a
rds_subnet_group_name=workshop2-subnet-group
rds_sgr_id=sg-0d540c37aac8736b6
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws rds create-db-instance \
    --db-instance-identifier $rds_name \
    --engine postgres \
    --db-name $rds_db_name \
    --db-instance-class db.t3.micro \
    --allocated-storage 20 \
    --master-username $rds_db_username \
    --master-user-password $rds_db_password \
    --storage-type gp2 \
    --no-enable-performance-insights \
    --availability-zone $az_01 \
    --db-subnet-group-name $rds_subnet_group_name \
    --vpc-security-group-ids $rds_sgr_id \
    --backup-retention-period 0 \
    --tags "$tags"
{
    "DBInstance": {
        "DBInstanceIdentifier": "workshop2-rds",
        "DBInstanceClass": "db.t3.micro",
        "Engine": "postgres",
        "DBInstanceStatus": "creating",
        "MasterUsername": "postgres",
        "DBName": "workshop",
        "AllocatedStorage": 20,
        "PreferredBackupWindow": "16:34-17:04",
        "BackupRetentionPeriod": 0,
        "DBSecurityGroups": [],
        "VpcSecurityGroups": [
            {
                "VpcSecurityGroupId": "sg-0d540c37aac8736b6",
                "Status": "active"
            }
        ],
        "DBParameterGroups": [
            {
                "DBParameterGroupName": "default.postgres16",
                "ParameterApplyStatus": "in-sync"
            }
        ],
        "AvailabilityZone": "ap-southeast-1a",
        "DBSubnetGroup": {
            "DBSubnetGroupName": "workshop2-subnet-group",
            "DBSubnetGroupDescription": "Subnet Group for Postgres RDS",
            "VpcId": "vpc-083f047268c20e7f3",
            "SubnetGroupStatus": "Complete",
            "Subnets": [
                {
                    "SubnetIdentifier": "subnet-0feb0bce83a36e8a7",
                    "SubnetAvailabilityZone": {
                        "Name": "ap-southeast-1b"
                    },
                    "SubnetOutpost": {},
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-06cbe85c62298e4c4",
                    "SubnetAvailabilityZone": {
                        "Name": "ap-southeast-1a"
                    },
                    "SubnetOutpost": {},
                    "SubnetStatus": "Active"
                }
            ]
        },
        "PreferredMaintenanceWindow": "sat:15:25-sat:15:55",
        "PendingModifiedValues": {
            "MasterUserPassword": "****"
        },
        "MultiAZ": false,
        "EngineVersion": "16.1",
        "AutoMinorVersionUpgrade": true,
        "ReadReplicaDBInstanceIdentifiers": [],
        "LicenseModel": "postgresql-license",
        "OptionGroupMemberships": [
            {
                "OptionGroupName": "default:postgres-16",
                "Status": "in-sync"
            }
        ],
        "PubliclyAccessible": false,
        "StorageType": "gp2",
        "DbInstancePort": 0,
        "StorageEncrypted": false,
        "DbiResourceId": "db-OWLATTHD7AMIP7JOS3Q5V2SJLY",
        "CACertificateIdentifier": "rds-ca-rsa2048-g1",
        "DomainMemberships": [],
        "CopyTagsToSnapshot": false,
        "MonitoringInterval": 0,
        "DBInstanceArn": "arn:aws:rds:ap-southeast-1:aws_account_id:db:workshop2-rds",
        "IAMDatabaseAuthenticationEnabled": false,
        "PerformanceInsightsEnabled": false,
        "DeletionProtection": false,
        "AssociatedRoles": [],
        "TagList": [
            {
                "Key": "purpose",
                "Value": "workshop2"
            },
            {
                "Key": "project",
                "Value": "fcj_workshop"
            },
            {
                "Key": "author",
                "Value": "pthach_cli"
            }
        ],
        "CustomerOwnedIpEnabled": false,
        "BackupTarget": "region",
        "NetworkType": "IPV4",
        "StorageThroughput": 0,
        "CertificateDetails": {
            "CAIdentifier": "rds-ca-rsa2048-g1"
        }
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws rds wait db-instance-available \
    --db-instance-identifier $rds_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ rds_address=$(aws rds describe-db-instances \
    --db-instance-identifier $rds_name \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo rds_address=$rds_address
rds_address=workshop2-rds.clotidgmnter.ap-southeast-1.rds.amazonaws.com
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "=========== secretsmanager"
=========== secretsmanager
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ secret_name=$project-sm
secret_string=$(echo "{\"POSTGRES_HOST\":\"$rds_address\",\"POSTGRES_PORT\":\"5432\",\"POSTGRES_DB\":\"$rds_db_name\",\"POSTGRES_USERNAME\":\"$rds_db_username\",\"POSTGRES_PASSWORD\":\"$rds_db_password\"}")
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo secret_name=$secret_name
echo secret_string=$secret_string
secret_name=workshop2-sm
secret_string={"POSTGRES_HOST":"workshop2-rds.clotidgmnter.ap-southeast-1.rds.amazonaws.com","POSTGRES_PORT":"5432","POSTGRES_DB":"workshop","POSTGRES_USERNAME":"postgres","POSTGRES_PASSWORD":"postgres"}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws secretsmanager create-secret \
    --name $secret_name \
    --description "To save database information" \
    --tags "$tags" \
    --secret-string $secret_string
{
    "ARN": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP",
    "Name": "workshop2-sm",
    "VersionId": "0c8ca003-7ebc-4e51-ace3-3d4cf880bcf8"
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ secret_arn=$(aws secretsmanager describe-secret --secret-id $secret_name --query 'ARN' --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo secret_arn=$secret_arn
secret_arn=arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ alb_name=$project-alb
alb_tgr_name=$project-tgr
alb_vpc_id=$vpc_id
alb_subnet1_id=$subnet_public_1
alb_subnet2_id=$subnet_public_2
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo alb_sgr_name=$alb_sgr_name
echo alb_name=$alb_name
echo alb_tgr_name=$alb_tgr_name
echo alb_vpc_id=$alb_vpc_id
echo alb_subnet1_id=$alb_subnet1_id
echo alb_subnet2_id=$alb_subnet2_id
echo alb_sgr_id=$alb_sgr_id
alb_sgr_name=workshop2-alb-sgr
alb_name=workshop2-alb
alb_tgr_name=workshop2-tgr
alb_vpc_id=vpc-083f047268c20e7f3
alb_subnet1_id=subnet-0166cf1c9a99f7726
alb_subnet2_id=subnet-01a1f1f7237ab5feb
alb_sgr_id=sg-0dcd139488f320ae2
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ alb_arn=$(aws elbv2 create-load-balancer \
    --name $alb_name  \
    --subnets $alb_subnet1_id $alb_subnet2_id \
    --security-groups $alb_sgr_id \
    --tags "$tags" \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo alb_arn=$alb_arn
alb_arn=arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:loadbalancer/app/workshop2-alb/d0558c692ba22e62
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ alb_tgr_arn=$(aws elbv2 create-target-group \
    --name $alb_tgr_name \
    --protocol HTTP \
    --target-type ip \
    --health-check-path "/api/product" \
    --port 8080 \
    --vpc-id $alb_vpc_id \
    --tags "$tags" \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo alb_tgr_arn=$alb_tgr_arn
alb_tgr_arn=arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ alb_listener_arn=$(aws elbv2 create-listener \
  --load-balancer-arn $alb_arn \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=$alb_tgr_arn \
  --query 'Listeners[0].ListenerArn' \
  --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo alb_listener_arn$alb_listener_arn
alb_listener_arnarn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:listener/app/workshop2-alb/d0558c692ba22e62/0b1dfc43c027aea3
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "============ECS cluster"
============ECS cluster
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_cluster_name=$project-cluster
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_cluster_name=$ecs_cluster_name
ecs_cluster_name=workshop2-cluster
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ # Create ECS Cluster
aws ecs create-cluster \
    --cluster-name $ecs_cluster_name \
    --region $region \
    --tags "$tags2"
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster",
        "clusterName": "workshop2-cluster",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [
            {
                "key": "purpose",
                "value": "workshop2"
            },
            {
                "key": "author",
                "value": "pthach_cli"
            },
            {
                "key": "project",
                "value": "fcj_workshop"
            }
        ],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs list-clusters
{
    "clusterArns": [
        "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster"
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "========ECS Capacity"
========ECS Capacity
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_ami_id=$(aws ssm get-parameters \
    --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
    --region $region | jq -r '.Parameters[0].Value | fromjson.image_id')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_ami_id=$ecs_instance_ami_id
ecs_instance_ami_id=ami-06d2f8d563560b42d
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_type=t3.medium
ecs_instance_subnet_id=$subnet_public_1
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_ami_id=$ecs_instance_ami_id
echo ecs_instance_type=$ecs_instance_type
echo ecs_instance_profile_arn=$ecs_instance_profile_arn
echo ecs_instance_sgr_id=$ecs_instance_sgr_id
echo ecs_instance_subnet_id=$ecs_instance_subnet_id
echo ecs_instance_key_name=$ecs_instance_key_name
ecs_instance_ami_id=ami-06d2f8d563560b42d
ecs_instance_type=t3.medium
ecs_instance_profile_arn=arn:aws:iam::aws_account_id:instance-profile/workshop2-ecs-instance-role
ecs_instance_sgr_id=sg-032aa58bc7026031c
ecs_instance_subnet_id=subnet-0166cf1c9a99f7726
ecs_instance_key_name=workshop2-keypair
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat <<EOF | tee ecs-launch-template.json
{
    "ImageId": "$ecs_instance_ami_id",
    "InstanceType": "$ecs_instance_type",
    "IamInstanceProfile": {
        "Arn": "$ecs_instance_profile_arn"
    },
    "NetworkInterfaces": [{
        "DeviceIndex": 0,
        "AssociatePublicIpAddress": true,
        "Groups": ["$ecs_instance_sgr_id"],
        "SubnetId": "$ecs_instance_subnet_id"
    }],
    "KeyName": "$ecs_instance_key_name",
    "TagSpecifications": [{
        "ResourceType": "instance",
        "Tags": `echo '['$tagspec | sed 's/{/{"/g; s/}/"}/g; s/,/","/g; s/}","{/},{/g; s/=/":"/g'`
    }],
    "UserData": "`cat <<EOF | openssl base64 -A
#!/bin/bash
echo ECS_CLUSTER=$ecs_cluster_name >> /etc/ecs/ecs.config
EOF`"
}
EOF
{
    "ImageId": "ami-06d2f8d563560b42d",
    "InstanceType": "t3.medium",
    "IamInstanceProfile": {
        "Arn": "arn:aws:iam::aws_account_id:instance-profile/workshop2-ecs-instance-role"
    },
    "NetworkInterfaces": [{
        "DeviceIndex": 0,
        "AssociatePublicIpAddress": true,
        "Groups": ["sg-032aa58bc7026031c"],
        "SubnetId": "subnet-0166cf1c9a99f7726"
    }],
    "KeyName": "workshop2-keypair",
    "TagSpecifications": [{
        "ResourceType": "instance",
        "Tags": [{"Key":"purpose","Value":"workshop2"},{"Key":"project","Value":"fcj_workshop"},{"Key":"author","Value":"pthach_cli"}]
    }],
    "UserData": "IyEvYmluL2Jhc2gKZWNobyBFQ1NfQ0xVU1RFUj13b3Jrc2hvcDItY2x1c3RlciA+PiAvZXRjL2Vjcy9lY3MuY29uZmlnCg=="
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
ecs-launch-template.json  workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat ecs-launch-template.json
{
    "ImageId": "ami-06d2f8d563560b42d",
    "InstanceType": "t3.medium",
    "IamInstanceProfile": {
        "Arn": "arn:aws:iam::aws_account_id:instance-profile/workshop2-ecs-instance-role"
    },
    "NetworkInterfaces": [{
        "DeviceIndex": 0,
        "AssociatePublicIpAddress": true,
        "Groups": ["sg-032aa58bc7026031c"],
        "SubnetId": "subnet-0166cf1c9a99f7726"
    }],
    "KeyName": "workshop2-keypair",
    "TagSpecifications": [{
        "ResourceType": "instance",
        "Tags": [{"Key":"purpose","Value":"workshop2"},{"Key":"project","Value":"fcj_workshop"},{"Key":"author","Value":"pthach_cli"}]
    }],
    "UserData": "IyEvYmluL2Jhc2gKZWNobyBFQ1NfQ0xVU1RFUj13b3Jrc2hvcDItY2x1c3RlciA+PiAvZXRjL2Vjcy9lY3MuY29uZmlnCg=="
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_launch_template_name=$project-ecs-launch-template
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_launch_template_name=$ecs_launch_template_name
ecs_launch_template_name=workshop2-ecs-launch-template
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-launch-template \
    --launch-template-name $ecs_launch_template_name \
    --launch-template-data file://ecs-launch-template.json
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-03e5866334a2f4701",
        "LaunchTemplateName": "workshop2-ecs-launch-template",
        "CreateTime": "2024-03-18T13:27:50+00:00",
        "CreatedBy": "arn:aws:iam::aws_account_id:user/AdminUser",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_instance_name=$project-ecs-instance
ecs_autoscaling_group_name=$project-ecs-autoscaling-group
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_instance_name=$ecs_instance_name
echo ecs_autoscaling_group_name=$ecs_autoscaling_group_name
echo ecs_launch_template_name=$ecs_launch_template_name
ecs_instance_name=workshop2-ecs-instance
ecs_autoscaling_group_name=workshop2-ecs-autoscaling-group
ecs_launch_template_name=workshop2-ecs-launch-template
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name $ecs_autoscaling_group_name \
    --launch-template "$(echo "{\"LaunchTemplateName\":\"$ecs_launch_template_name\"}")" \
    --min-size 1 \
    --max-size 3 \
    --desired-capacity 1 \
    --tags "$(echo $tags | jq -c '. + [{"Key":"Name","Value":"'"$ecs_instance_name"'"}]')"
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_autoscaling_group_arn=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ecs_autoscaling_group_name \
    | jq .AutoScalingGroups[0].AutoScalingGroupARN)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_autoscaling_group_arn=$ecs_autoscaling_group_arn
ecs_autoscaling_group_arn="arn:aws:autoscaling:ap-southeast-1:aws_account_id:autoScalingGroup:70132131-06ce-40c4-99ca-526a40e03d68:autoScalingGroupName/workshop2-ecs-autoscaling-group"
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs list-container-instances --cluster $ecs_cluster_name
{
    "containerInstanceArns": [
        "arn:aws:ecs:ap-southeast-1:aws_account_id:container-instance/workshop2-cluster/b00c3c91ff344bd9b83d311e0f309b71"
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_capacity_provider=$project-capacity-provider
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_capacity_provider=$ecs_capacity_provider
ecs_capacity_provider=workshop2-capacity-provider
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs create-capacity-provider \
    --name $ecs_capacity_provider \
    --auto-scaling-group-provider `echo "autoScalingGroupArn=$ecs_autoscaling_group_arn,managedScaling={status=ENABLED,targetCapacity=100},managedTerminationProtection=DISABLED"`
{
    "capacityProvider": {
        "capacityProviderArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:capacity-provider/workshop2-capacity-provider",
        "name": "workshop2-capacity-provider",
        "status": "ACTIVE",
        "autoScalingGroupProvider": {
            "autoScalingGroupArn": "arn:aws:autoscaling:ap-southeast-1:aws_account_id:autoScalingGroup:70132131-06ce-40c4-99ca-526a40e03d68:autoScalingGroupName/workshop2-ecs-autoscaling-group",
            "managedScaling": {
                "status": "ENABLED",
                "targetCapacity": 100,
                "minimumScalingStepSize": 1,
                "maximumScalingStepSize": 10000,
                "instanceWarmupPeriod": 300
            },
            "managedTerminationProtection": "DISABLED"
        },
        "tags": []
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs put-cluster-capacity-providers \
    --cluster $ecs_cluster_name \
    --capacity-providers $ecs_capacity_provider \
    --default-capacity-provider-strategy capacityProvider=$ecs_capacity_provider,weight=1
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster",
        "clusterName": "workshop2-cluster",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [
            "workshop2-capacity-provider"
        ],
        "defaultCapacityProviderStrategy": [
            {
                "capacityProvider": "workshop2-capacity-provider",
                "weight": 1,
                "base": 0
            }
        ],
        "attachments": [
            {
                "id": "4baef80a-833a-4600-993f-6fae66033391",
                "type": "as_policy",
                "status": "PRECREATED",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "workshop2-capacity-provider"
                    },
                    {
                        "name": "scalingPolicyName",
                        "value": "ECSManagedAutoScalingPolicy-a22627fe-49ad-4241-8019-f0b4672a646c"
                    }
                ]
            },
            {
                "id": "26c2636f-83ca-4e33-a83d-c3c61f772219",
                "type": "managed_draining",
                "status": "PRECREATED",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "workshop2-capacity-provider"
                    },
                    {
                        "name": "autoScalingLifecycleHookName",
                        "value": "ecs-managed-draining-termination-hook"
                    }
                ]
            }
        ],
        "attachmentsStatus": "UPDATE_IN_PROGRESS"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "========== task definition"
========== task definition
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo secret_arn=$secret_arn
secret_arn=arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_task_role_name=$project-ecs-task-role
ecs_task_policy_name=${project}_ecs_task_policy
ecs_task_name=$project-task
ecs_task_uri=$ecr_image_uri
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_task_role_name=$ecs_task_role_name
echo ecs_task_policy_name=$ecs_task_policy_name
echo ecs_task_name=$ecs_task_name
echo ecs_task_uri=$ecs_task_uri
ecs_task_role_name=workshop2-ecs-task-role
ecs_task_policy_name=workshop2_ecs_task_policy
ecs_task_name=workshop2-task
ecs_task_uri=aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_task_role_arn=$(aws iam create-role \
    --role-name $ecs_task_role_name \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": ["sts:AssumeRole"]
        }]
    }' \
    --tags "$tags" \
    --output text \
    --query 'Role.Arn')
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_task_role_arn=$ecs_task_role_arn
ecs_task_role_arn=arn:aws:iam::aws_account_id:role/workshop2-ecs-task-role
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat <<EOF | tee ecs-task-role.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "`echo $secret_arn`",
        "`echo $secret_arn`*"
      ]
    }
  ]
}
EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP",
        "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP*"
      ]
    }
  ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
ecs-launch-template.json  ecs-task-role.json  workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat ecs-task-role.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP",
        "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP*"
      ]
    }
  ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam put-role-policy \
    --role-name $ecs_task_role_name \
    --policy-name $ecs_task_policy_name \
    --policy-document file://ecs-task-role.json
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
    --role-name $ecs_task_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
ecs-launch-template.json  ecs-task-role.json  workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat <<EOF | tee task-definition.json
{
    "name": "$ecs_task_name",
    "image": "$ecs_task_uri",
    "portMappings": [
        {
            "containerPort": 8080,
            "hostPort": 8080
        }
    ],
    "secrets" : [
        {
            "valueFrom" : "$secret_arn:POSTGRES_HOST::",
            "name" : "POSTGRES_HOST"
        },
        {
            "valueFrom" : "$secret_arn:POSTGRES_DB::",
            "name" : "POSTGRES_DB"
        },
        {
            "valueFrom" : "$secret_arn:POSTGRES_PASSWORD::",
            "name" : "POSTGRES_PASSWORD"
        }
    ]
}
EOF
{
    "name": "workshop2-task",
    "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest",
    "portMappings": [
        {
            "containerPort": 8080,
            "hostPort": 8080
        }
    ],
    "secrets" : [
        {
            "valueFrom" : "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::",
            "name" : "POSTGRES_HOST"
        },
        {
            "valueFrom" : "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::",
            "name" : "POSTGRES_DB"
        },
        {
            "valueFrom" : "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::",
            "name" : "POSTGRES_PASSWORD"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
ecs-launch-template.json  ecs-task-role.json  task-definition.json  workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ls
ecs-launch-template.json  ecs-task-role.json  task-definition.json  workshop2-keypair.pem
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ cat task-definition.json
{
    "name": "workshop2-task",
    "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest",
    "portMappings": [
        {
            "containerPort": 8080,
            "hostPort": 8080
        }
    ],
    "secrets" : [
        {
            "valueFrom" : "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::",
            "name" : "POSTGRES_HOST"
        },
        {
            "valueFrom" : "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::",
            "name" : "POSTGRES_DB"
        },
        {
            "valueFrom" : "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::",
            "name" : "POSTGRES_PASSWORD"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_task_definition=$(aws ecs register-task-definition \
    --family $ecs_task_name \
    --network-mode awsvpc \
    --requires-compatibilities EC2 \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn "$ecs_task_role_arn" \
    --tags "$tags2" \
    --container-definitions "`jq -c . task-definition.json`" )
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs list-task-definitions
{
    "taskDefinitionArns": [
        "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3"
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_task_arn=$(aws ecs describe-task-definition \
    --task-definition $ecs_task_name \
    --query "taskDefinition.taskDefinitionArn" \
    --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_task_arn=$ecs_task_arn
ecs_task_arn=arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "=================== service"
=================== service
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_service_name=$project-service
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_cluster_name=$ecs_cluster_name
echo ecs_service_name=$ecs_service_name
echo ecs_task_arn=$ecs_task_arn
ecs_cluster_name=workshop2-cluster
ecs_service_name=workshop2-service
ecs_task_arn=arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs create-service \
   --cluster $ecs_cluster_name \
   --service-name $ecs_service_name \
   --task-definition $ecs_task_arn \
   --desired-count 1 \
   --network-configuration "awsvpcConfiguration={subnets=[$ecs_instance_subnet_id],securityGroups=[$ecs_instance_sgr_id]}" \

{
    "service": {
        "serviceArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:service/workshop2-cluster/workshop2-service",
        "serviceName": "workshop2-service",
        "clusterArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster",
        "loadBalancers": [],
        "serviceRegistries": [],
        "status": "ACTIVE",
        "desiredCount": 1,
        "runningCount": 0,
        "pendingCount": 0,
        "capacityProviderStrategy": [
            {
                "capacityProvider": "workshop2-capacity-provider",
                "weight": 1,
                "base": 0
            }
        ],
        "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
        "deploymentConfiguration": {
            "deploymentCircuitBreaker": {
                "enable": false,
                "rollback": false
            },
            "maximumPercent": 200,
            "minimumHealthyPercent": 100
        },
        "deployments": [
            {
                "id": "ecs-svc/1300438791906357494",
                "status": "PRIMARY",
                "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
                "desiredCount": 1,
                "pendingCount": 0,
                "runningCount": 0,
                "failedTasks": 0,
                "createdAt": "2024-03-18T21:13:35.363000+07:00",
                "updatedAt": "2024-03-18T21:13:35.363000+07:00",
                "capacityProviderStrategy": [
                    {
                        "capacityProvider": "workshop2-capacity-provider",
                        "weight": 1,
                        "base": 0
                    }
                ],
                "networkConfiguration": {
                    "awsvpcConfiguration": {
                        "subnets": [
                            "subnet-0166cf1c9a99f7726"
                        ],
                        "securityGroups": [
                            "sg-032aa58bc7026031c"
                        ],
                        "assignPublicIp": "DISABLED"
                    }
                },
                "rolloutState": "IN_PROGRESS",
                "rolloutStateReason": "ECS deployment ecs-svc/1300438791906357494 in progress."
            }
        ],
        "roleArn": "arn:aws:iam::aws_account_id:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS",
        "events": [],
        "createdAt": "2024-03-18T21:13:35.363000+07:00",
        "placementConstraints": [],
        "placementStrategy": [],
        "networkConfiguration": {
            "awsvpcConfiguration": {
                "subnets": [
                    "subnet-0166cf1c9a99f7726"
                ],
                "securityGroups": [
                    "sg-032aa58bc7026031c"
                ],
                "assignPublicIp": "DISABLED"
            }
        },
        "schedulingStrategy": "REPLICA",
        "deploymentController": {
            "type": "ECS"
        },
        "createdBy": "arn:aws:iam::aws_account_id:user/AdminUser",
        "enableECSManagedTags": false,
        "propagateTags": "NONE",
        "enableExecuteCommand": false
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo ecs_cluster_name=$ecs_cluster_name
echo ecs_service_name=$ecs_service_name
echo ecs_task_definition=$ecs_task_definition
ecs_cluster_name=workshop2-cluster
ecs_service_name=workshop2-service
ecs_task_definition={ "taskDefinition": { "taskDefinitionArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3", "containerDefinitions": [ { "name": "workshop2-task", "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest", "cpu": 0, "portMappings": [ { "containerPort": 8080, "hostPort": 8080, "protocol": "tcp" } ], "essential": true, "environment": [], "mountPoints": [], "volumesFrom": [], "secrets": [ { "name": "POSTGRES_HOST", "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::" }, { "name": "POSTGRES_DB", "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::" }, { "name": "POSTGRES_PASSWORD", "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::" } ], "systemControls": [] } ], "family": "workshop2-task", "executionRoleArn": "arn:aws:iam::aws_account_id:role/workshop2-ecs-task-role", "networkMode": "awsvpc", "revision": 3, "volumes": [], "status": "ACTIVE", "requiresAttributes": [ { "name": "com.amazonaws.ecs.capability.ecr-auth" }, { "name": "ecs.capability.secrets.asm.environment-variables" }, { "name": "ecs.capability.execution-role-ecr-pull" }, { "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18" }, { "name": "ecs.capability.task-eni" } ], "placementConstraints": [], "compatibilities": [ "EC2", "FARGATE" ], "requiresCompatibilities": [ "EC2" ], "cpu": "256", "memory": "512", "registeredAt": "2024-03-18T20:53:25.123000+07:00", "registeredBy": "arn:aws:iam::aws_account_id:user/AdminUser" }, "tags": [ { "key": "purpose", "value": "workshop2" }, { "key": "project", "value": "fcj_workshop" }, { "key": "author", "value": "pthach_cli" } ] }
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs update-service --cluster $ecs_cluster_name \
    --service $ecs_service_name \
    --desired-count 1 \
    --load-balancers targetGroupArn=$alb_tgr_arn,containerName=`echo $ecs_task_definition | jq -r '.taskDefinition.containerDefinitions[0].name'`,containerPort=8080
{
    "service": {
        "serviceArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:service/workshop2-cluster/workshop2-service",
        "serviceName": "workshop2-service",
        "clusterArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster",
        "loadBalancers": [
            {
                "targetGroupArn": "arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f",
                "containerName": "workshop2-task",
                "containerPort": 8080
            }
        ],
        "serviceRegistries": [],
        "status": "ACTIVE",
        "desiredCount": 1,
        "runningCount": 1,
        "pendingCount": 0,
        "capacityProviderStrategy": [
            {
                "capacityProvider": "workshop2-capacity-provider",
                "weight": 1,
                "base": 0
            }
        ],
        "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
        "deploymentConfiguration": {
            "deploymentCircuitBreaker": {
                "enable": false,
                "rollback": false
            },
            "maximumPercent": 200,
            "minimumHealthyPercent": 100
        },
        "deployments": [
            {
                "id": "ecs-svc/5578260264892541909",
                "status": "PRIMARY",
                "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
                "desiredCount": 0,
                "pendingCount": 0,
                "runningCount": 0,
                "failedTasks": 0,
                "createdAt": "2024-03-18T21:14:50.421000+07:00",
                "updatedAt": "2024-03-18T21:14:50.421000+07:00",
                "capacityProviderStrategy": [
                    {
                        "capacityProvider": "workshop2-capacity-provider",
                        "weight": 1,
                        "base": 0
                    }
                ],
                "networkConfiguration": {
                    "awsvpcConfiguration": {
                        "subnets": [
                            "subnet-0166cf1c9a99f7726"
                        ],
                        "securityGroups": [
                            "sg-032aa58bc7026031c"
                        ],
                        "assignPublicIp": "DISABLED"
                    }
                },
                "rolloutState": "IN_PROGRESS",
                "rolloutStateReason": "ECS deployment ecs-svc/5578260264892541909 in progress."
            },
            {
                "id": "ecs-svc/1300438791906357494",
                "status": "ACTIVE",
                "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
                "desiredCount": 1,
                "pendingCount": 0,
                "runningCount": 1,
                "failedTasks": 0,
                "createdAt": "2024-03-18T21:13:35.363000+07:00",
                "updatedAt": "2024-03-18T21:14:18.210000+07:00",
                "capacityProviderStrategy": [
                    {
                        "capacityProvider": "workshop2-capacity-provider",
                        "weight": 1,
                        "base": 0
                    }
                ],
                "networkConfiguration": {
                    "awsvpcConfiguration": {
                        "subnets": [
                            "subnet-0166cf1c9a99f7726"
                        ],
                        "securityGroups": [
                            "sg-032aa58bc7026031c"
                        ],
                        "assignPublicIp": "DISABLED"
                    }
                },
                "rolloutState": "COMPLETED",
                "rolloutStateReason": "ECS deployment ecs-svc/1300438791906357494 completed."
            }
        ],
        "roleArn": "arn:aws:iam::aws_account_id:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS",
        "events": [
            {
                "id": "b7b7ff86-bbb1-43c4-b3ad-ca4198a68226",
                "createdAt": "2024-03-18T21:14:18.217000+07:00",
                "message": "(service workshop2-service) has reached a steady state."
            },
            {
                "id": "ce0eb3d5-3138-4609-bef6-d6836a94e011",
                "createdAt": "2024-03-18T21:14:18.216000+07:00",
                "message": "(service workshop2-service) (deployment ecs-svc/1300438791906357494) deployment completed."
            },
            {
                "id": "7dbc8aee-43fc-4ef4-bbab-af27d7cff8a6",
                "createdAt": "2024-03-18T21:13:47.806000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/1300438791906357494) has started 1 tasks: (task 807934e8668a4ee79d7d471e2d886d68)."
            },
            {
                "id": "9a93f26c-9514-4e60-9a0a-8cafb89bf33f",
                "createdAt": "2024-03-18T21:13:45.989000+07:00",
                "message": "(service workshop2-service) has started 1 tasks: (task 807934e8668a4ee79d7d471e2d886d68)."
            }
        ],
        "createdAt": "2024-03-18T21:13:35.363000+07:00",
        "placementConstraints": [],
        "placementStrategy": [],
        "networkConfiguration": {
            "awsvpcConfiguration": {
                "subnets": [
                    "subnet-0166cf1c9a99f7726"
                ],
                "securityGroups": [
                    "sg-032aa58bc7026031c"
                ],
                "assignPublicIp": "DISABLED"
            }
        },
        "schedulingStrategy": "REPLICA",
        "deploymentController": {
            "type": "ECS"
        },
        "createdBy": "arn:aws:iam::aws_account_id:user/AdminUser",
        "enableECSManagedTags": false,
        "propagateTags": "NONE",
        "enableExecuteCommand": false
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
{
    "TargetHealthDescriptions": [
        {
            "Target": {
                "Id": "10.1.3.141",
                "Port": 8080,
                "AvailabilityZone": "ap-southeast-1a"
            },
            "HealthCheckPort": "8080",
            "TargetHealth": {
                "State": "draining",
                "Reason": "Target.DeregistrationInProgress",
                "Description": "Target deregistration is in progress"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-load-balancers \
    --load-balancer-arns $alb_arn \
    --query 'LoadBalancers[0].DNSName' \
    --output text
workshop2-alb-528875279.ap-southeast-1.elb.amazonaws.com
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
{
    "TargetHealthDescriptions": [
        {
            "Target": {
                "Id": "10.1.3.84",
                "Port": 8080,
                "AvailabilityZone": "ap-southeast-1a"
            },
            "HealthCheckPort": "8080",
            "TargetHealth": {
                "State": "unhealthy",
                "Reason": "Target.ResponseCodeMismatch",
                "Description": "Health checks failed with these codes: [404]"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
{
    "TargetHealthDescriptions": [
        {
            "Target": {
                "Id": "10.1.3.84",
                "Port": 8080,
                "AvailabilityZone": "ap-southeast-1a"
            },
            "HealthCheckPort": "8080",
            "TargetHealth": {
                "State": "unhealthy",
                "Reason": "Target.ResponseCodeMismatch",
                "Description": "Health checks failed with these codes: [404]"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
{
    "TargetHealthDescriptions": [
        {
            "Target": {
                "Id": "10.1.3.84",
                "Port": 8080,
                "AvailabilityZone": "ap-southeast-1a"
            },
            "HealthCheckPort": "8080",
            "TargetHealth": {
                "State": "draining",
                "Reason": "Target.DeregistrationInProgress",
                "Description": "Target deregistration is in progress"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-load-balancers \
    --load-balancer-arns $alb_arn \
    --query 'LoadBalancers[0].DNSName' \
    --output text
workshop2-alb-528875279.ap-southeast-1.elb.amazonaws.com
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 modify-target-group \
    --target-group-arn $alb_tgr_arn \
    --no-health-check-enabled

An error occurred (InvalidConfigurationRequest) when calling the ModifyTargetGroup operation: Health check enabled must be true for target groups with target type 'ip'
  ubuntu@thachpham  ~/firtcloudjourney/temp    $ aws elbv2 modify-target-group \
    --target-group-arn $alb_tgr_arn \
    --health-check-path "/api/product/
> ^C
  ubuntu@thachpham  ~/firtcloudjourney/temp    $ ^C
  ubuntu@thachpham  ~/firtcloudjourney/temp    $ aws elbv2 modify-target-group \
    --target-group-arn $alb_tgr_arn \
    --health-check-path "/api/product/"

{
    "TargetGroups": [
        {
            "TargetGroupArn": "arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f",
            "TargetGroupName": "workshop2-tgr",
            "Protocol": "HTTP",
            "Port": 8080,
            "VpcId": "vpc-083f047268c20e7f3",
            "HealthCheckProtocol": "HTTP",
            "HealthCheckPort": "traffic-port",
            "HealthCheckEnabled": true,
            "HealthCheckIntervalSeconds": 30,
            "HealthCheckTimeoutSeconds": 5,
            "HealthyThresholdCount": 5,
            "UnhealthyThresholdCount": 2,
            "HealthCheckPath": "/api/product/",
            "Matcher": {
                "HttpCode": "200"
            },
            "LoadBalancerArns": [
                "arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:loadbalancer/app/workshop2-alb/d0558c692ba22e62"
            ],
            "TargetType": "ip",
            "ProtocolVersion": "HTTP1",
            "IpAddressType": "ipv4"
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn
{
    "TargetHealthDescriptions": [
        {
            "Target": {
                "Id": "10.1.10.79",
                "Port": 8080,
                "AvailabilityZone": "ap-southeast-1a"
            },
            "HealthCheckPort": "8080",
            "TargetHealth": {
                "State": "healthy"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws elbv2 delete-listener --listener-arn $alb_listener_arn
aws elbv2 delete-target-group --target-group-arn $alb_tgr_arn
aws elbv2 delete-load-balancer --load-balancer-arn $alb_arn
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs delete-service --cluster $ecs_cluster_name \
    --service $ecs_service_name --force
{
    "service": {
        "serviceArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:service/workshop2-cluster/workshop2-service",
        "serviceName": "workshop2-service",
        "clusterArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster",
        "loadBalancers": [
            {
                "targetGroupArn": "arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f",
                "containerName": "workshop2-task",
                "containerPort": 8080
            }
        ],
        "serviceRegistries": [],
        "status": "DRAINING",
        "desiredCount": 0,
        "runningCount": 1,
        "pendingCount": 0,
        "capacityProviderStrategy": [
            {
                "capacityProvider": "workshop2-capacity-provider",
                "weight": 1,
                "base": 0
            }
        ],
        "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:4",
        "deploymentConfiguration": {
            "deploymentCircuitBreaker": {
                "enable": false,
                "rollback": false
            },
            "maximumPercent": 200,
            "minimumHealthyPercent": 100
        },
        "deployments": [
            {
                "id": "ecs-svc/4861563668017469206",
                "status": "PRIMARY",
                "taskDefinition": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:4",
                "desiredCount": 0,
                "pendingCount": 0,
                "runningCount": 1,
                "failedTasks": 0,
                "createdAt": "2024-03-18T21:57:58.101000+07:00",
                "updatedAt": "2024-03-18T22:02:41.712000+07:00",
                "capacityProviderStrategy": [
                    {
                        "capacityProvider": "workshop2-capacity-provider",
                        "weight": 1,
                        "base": 0
                    }
                ],
                "networkConfiguration": {
                    "awsvpcConfiguration": {
                        "subnets": [
                            "subnet-0166cf1c9a99f7726"
                        ],
                        "securityGroups": [
                            "sg-032aa58bc7026031c"
                        ],
                        "assignPublicIp": "DISABLED"
                    }
                },
                "rolloutState": "COMPLETED",
                "rolloutStateReason": "ECS deployment ecs-svc/4861563668017469206 completed."
            }
        ],
        "roleArn": "arn:aws:iam::aws_account_id:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS",
        "events": [
            {
                "id": "cdc1e4f6-06c5-4ce0-983f-5145fcd8469e",
                "createdAt": "2024-03-18T22:00:22.739000+07:00",
                "message": "(service workshop2-service) has reached a steady state."
            },
            {
                "id": "a7ff12f1-ca23-4467-9a5d-f27ed51abfda",
                "createdAt": "2024-03-18T22:00:22.738000+07:00",
                "message": "(service workshop2-service) (deployment ecs-svc/4861563668017469206) deployment completed."
            },
            {
                "id": "cbfc481b-2426-435d-a90a-06ce2c517d86",
                "createdAt": "2024-03-18T21:59:46.739000+07:00",
                "message": "(service workshop2-service) has stopped 1 running tasks: (task 807934e8668a4ee79d7d471e2d886d68)."
            },
            {
                "id": "b45ee528-be63-422d-b1d2-a9cad3a358f6",
                "createdAt": "2024-03-18T21:58:56.661000+07:00",
                "message": "(service workshop2-service) registered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "2ec118de-3ece-4eff-b5ff-e7b83dcb21ce",
                "createdAt": "2024-03-18T21:58:37.824000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/4861563668017469206) has started 1 tasks: (task 95cd875055354d0497a7241a83ae9f00)."
            },
            {
                "id": "231314c3-423c-4be6-aba9-acc4fa5ad885",
                "createdAt": "2024-03-18T21:58:37.448000+07:00",
                "message": "(service workshop2-service) has started 1 tasks: (task 95cd875055354d0497a7241a83ae9f00)."
            },
            {
                "id": "2c038b68-e280-479e-8f3d-df5234f7a7ce",
                "createdAt": "2024-03-18T21:53:07.461000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "0a2d04bd-0dfd-4b3e-b766-685380bda038",
                "createdAt": "2024-03-18T21:53:07.375000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has begun draining connections on 1 tasks."
            },
            {
                "id": "d397e4fa-6100-4b8b-8be7-5544153c60f8",
                "createdAt": "2024-03-18T21:53:07.371000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "b675a478-a2a1-4f5c-ae20-0bbb36acf59c",
                "createdAt": "2024-03-18T21:52:57.532000+07:00",
                "message": "(service workshop2-service) has stopped 1 running tasks: (task 63f054c757384ae28b7c871841c5c206)."
            },
            {
                "id": "62356856-b412-458d-b29e-11b9a5bfabe1",
                "createdAt": "2024-03-18T21:52:57.497000+07:00",
                "message": "(service workshop2-service) (instance 10.1.11.228) (port 8080) is unhealthy in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f) due to (reason Health checks failed)"
            },
            {
                "id": "64da7105-e2b6-402e-821c-3bfd4fd33b35",
                "createdAt": "2024-03-18T21:50:21.741000+07:00",
                "message": "(service workshop2-service) registered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "f4445adc-d97d-40a6-85a2-a2de64896c1b",
                "createdAt": "2024-03-18T21:50:05.454000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has started 1 tasks: (task 63f054c757384ae28b7c871841c5c206)."
            },
            {
                "id": "fcc44373-5cc5-437b-8b9e-5d4606e29cea",
                "createdAt": "2024-03-18T21:50:01.052000+07:00",
                "message": "(service workshop2-service) has started 1 tasks: (task 63f054c757384ae28b7c871841c5c206)."
            },
            {
                "id": "b4a570b9-c258-492c-922e-146cafec0f24",
                "createdAt": "2024-03-18T21:44:29.359000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "7c00bdb5-a57e-4e05-a7fc-997e227a0689",
                "createdAt": "2024-03-18T21:44:29.271000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has begun draining connections on 1 tasks."
            },
            {
                "id": "f3598b17-a38f-45bf-b2e0-5327001254b5",
                "createdAt": "2024-03-18T21:44:29.266000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "9e50c545-14d9-4368-9f53-ac51cfb42237",
                "createdAt": "2024-03-18T21:44:19.162000+07:00",
                "message": "(service workshop2-service) has stopped 1 running tasks: (task 05793dd4740445b0bf17e6f9f73bf243)."
            },
            {
                "id": "75d0cc2f-9b7d-4d18-9a83-36f3d442fb0d",
                "createdAt": "2024-03-18T21:44:19.112000+07:00",
                "message": "(service workshop2-service) (instance 10.1.0.135) (port 8080) is unhealthy in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f) due to (reason Health checks failed with these codes: [404])"
            },
            {
                "id": "a3feec11-bf57-4cb9-b8ff-b34e1862c8bd",
                "createdAt": "2024-03-18T21:41:44.962000+07:00",
                "message": "(service workshop2-service) registered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "c5796933-19dc-4646-b8ec-a608d15ec619",
                "createdAt": "2024-03-18T21:41:27.722000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has started 1 tasks: (task 05793dd4740445b0bf17e6f9f73bf243)."
            },
            {
                "id": "e481f806-997c-411e-8ea1-8feb8e24dc55",
                "createdAt": "2024-03-18T21:41:24.662000+07:00",
                "message": "(service workshop2-service) has started 1 tasks: (task 05793dd4740445b0bf17e6f9f73bf243)."
            },
            {
                "id": "6370cbfb-8f59-467a-a486-0a2ad87d168d",
                "createdAt": "2024-03-18T21:35:47.158000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "27b6c69d-5b93-4e90-9c67-313a2c04f640",
                "createdAt": "2024-03-18T21:35:47.048000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has begun draining connections on 1 tasks."
            },
            {
                "id": "bf6fef64-95ae-4859-8d69-7304eafee5a5",
                "createdAt": "2024-03-18T21:35:47.045000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "958b4e4d-cab1-409c-bbc0-f4e5b2c533eb",
                "createdAt": "2024-03-18T21:35:36.973000+07:00",
                "message": "(service workshop2-service) has stopped 1 running tasks: (task a8b490cec4bc430cb9ee0db2a067d4c7)."
            },
            {
                "id": "ef629547-2cc5-4749-ae76-efa8e8384263",
                "createdAt": "2024-03-18T21:35:36.914000+07:00",
                "message": "(service workshop2-service) (instance 10.1.14.204) (port 8080) is unhealthy in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f) due to (reason Health checks failed)"
            },
            {
                "id": "f4a207f9-ddee-4fe7-9b8c-73974721f8b7",
                "createdAt": "2024-03-18T21:33:02.362000+07:00",
                "message": "(service workshop2-service) registered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "60ae6576-31e9-4816-a026-0606f68b0bbd",
                "createdAt": "2024-03-18T21:32:42.728000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has started 1 tasks: (task a8b490cec4bc430cb9ee0db2a067d4c7)."
            },
            {
                "id": "745ee1bd-6289-4a92-b32d-41b7a91a903c",
                "createdAt": "2024-03-18T21:32:41.571000+07:00",
                "message": "(service workshop2-service) has started 1 tasks: (task a8b490cec4bc430cb9ee0db2a067d4c7)."
            },
            {
                "id": "6426bd6d-5320-49e7-88d1-6a96089bb650",
                "createdAt": "2024-03-18T21:27:15.592000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "c147e149-0b22-4b5e-ae63-4d958303fab3",
                "createdAt": "2024-03-18T21:27:15.511000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has begun draining connections on 1 tasks."
            },
            {
                "id": "75470775-d76c-45ce-b0fd-d7817f908d44",
                "createdAt": "2024-03-18T21:27:15.507000+07:00",
                "message": "(service workshop2-service) deregistered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "ab095744-76f5-4570-b08c-7e883d63ac81",
                "createdAt": "2024-03-18T21:27:02.654000+07:00",
                "message": "(service workshop2-service) has stopped 1 running tasks: (task 9e9ebb674f15402981d4dc8f1f955d99)."
            },
            {
                "id": "ea79e64a-fc28-4c23-ac8b-88d41ba326a1",
                "createdAt": "2024-03-18T21:27:02.613000+07:00",
                "message": "(service workshop2-service) (instance 10.1.3.84) (port 8080) is unhealthy in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f) due to (reason Health checks failed with these codes: [404])"
            },
            {
                "id": "b68a7926-e74b-468e-bab2-f24397fce499",
                "createdAt": "2024-03-18T21:24:14.746000+07:00",
                "message": "(service workshop2-service) registered 1 targets in (target-group arn:aws:elasticloadbalancing:ap-southeast-1:aws_account_id:targetgroup/workshop2-tgr/9f4c793fa8d7b87f)"
            },
            {
                "id": "b0a8148e-8325-4590-9765-fb19af1533e2",
                "createdAt": "2024-03-18T21:23:47.719000+07:00",
                "message": "(service workshop2-service, taskSet ecs-svc/5578260264892541909) has started 1 tasks: (task 9e9ebb674f15402981d4dc8f1f955d99)."
            },
            {
                "id": "b8bba18f-b589-4124-a389-539bd07ea849",
                "createdAt": "2024-03-18T21:23:44.487000+07:00",
                "message": "(service workshop2-service) has started 1 tasks: (task 9e9ebb674f15402981d4dc8f1f955d99)."
            },
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ task_definition_arns=$(aws ecs list-task-definitions \
    --status ACTIVE \
    --query 'taskDefinitionArns[]' --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ for arn in $task_definition_arns; do
    aws ecs deregister-task-definition --task-definition $arn
done
{
    "taskDefinition": {
        "taskDefinitionArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
        "containerDefinitions": [
            {
                "name": "workshop2-task",
                "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest",
                "cpu": 0,
                "portMappings": [
                    {
                        "containerPort": 8080,
                        "hostPort": 8080,
                        "protocol": "tcp"
                    }
                ],
                "essential": true,
                "environment": [],
                "mountPoints": [],
                "volumesFrom": [],
                "secrets": [
                    {
                        "name": "POSTGRES_HOST",
                        "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::"
                    },
                    {
                        "name": "POSTGRES_DB",
                        "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::"
                    },
                    {
                        "name": "POSTGRES_PASSWORD",
                        "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::"
                    }
                ],
                "systemControls": []
            }
        ],
        "family": "workshop2-task",
        "executionRoleArn": "arn:aws:iam::aws_account_id:role/workshop2-ecs-task-role",
        "networkMode": "awsvpc",
        "revision": 3,
        "volumes": [],
        "status": "INACTIVE",
        "requiresAttributes": [
            {
                "name": "com.amazonaws.ecs.capability.ecr-auth"
            },
            {
                "name": "ecs.capability.secrets.asm.environment-variables"
            },
            {
                "name": "ecs.capability.execution-role-ecr-pull"
            },
            {
                "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
            },
            {
                "name": "ecs.capability.task-eni"
            }
        ],
        "placementConstraints": [],
        "compatibilities": [
            "EC2",
            "FARGATE"
        ],
        "requiresCompatibilities": [
            "EC2"
        ],
        "cpu": "256",
        "memory": "512",
        "registeredAt": "2024-03-18T20:53:25.123000+07:00",
        "registeredBy": "arn:aws:iam::aws_account_id:user/AdminUser"
    }
}
{
    "taskDefinition": {
        "taskDefinitionArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:4",
        "containerDefinitions": [
            {
                "name": "workshop2-task",
                "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest",
                "cpu": 0,
                "portMappings": [
                    {
                        "containerPort": 8080,
                        "hostPort": 8080,
                        "protocol": "tcp"
                    }
                ],
                "essential": true,
                "environment": [],
                "mountPoints": [],
                "volumesFrom": [],
                "secrets": [
                    {
                        "name": "POSTGRES_HOST",
                        "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::"
                    },
                    {
                        "name": "POSTGRES_DB",
                        "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::"
                    },
                    {
                        "name": "POSTGRES_PASSWORD",
                        "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::"
                    }
                ],
                "systemControls": []
            }
        ],
        "family": "workshop2-task",
        "executionRoleArn": "arn:aws:iam::aws_account_id:role/workshop2-ecs-task-role",
        "networkMode": "awsvpc",
        "revision": 4,
        "volumes": [],
        "status": "INACTIVE",
        "requiresAttributes": [
            {
                "name": "com.amazonaws.ecs.capability.ecr-auth"
            },
            {
                "name": "ecs.capability.secrets.asm.environment-variables"
            },
            {
                "name": "ecs.capability.execution-role-ecr-pull"
            },
            {
                "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
            },
            {
                "name": "ecs.capability.task-eni"
            }
        ],
        "placementConstraints": [],
        "compatibilities": [
            "EC2",
            "FARGATE"
        ],
        "requiresCompatibilities": [
            "EC2"
        ],
        "cpu": "512",
        "memory": "1024",
        "registeredAt": "2024-03-18T21:57:32.371000+07:00",
        "registeredBy": "arn:aws:iam::aws_account_id:user/AdminUser"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ task_definition_inactive_arns=$(aws ecs list-task-definitions \
    --status INACTIVE \
    --query 'taskDefinitionArns[]' --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs delete-task-definitions \
    --task-definitions $task_definition_inactive_arns
{
    "taskDefinitions": [
        {
            "taskDefinitionArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:3",
            "containerDefinitions": [
                {
                    "name": "workshop2-task",
                    "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest",
                    "cpu": 0,
                    "portMappings": [
                        {
                            "containerPort": 8080,
                            "hostPort": 8080,
                            "protocol": "tcp"
                        }
                    ],
                    "essential": true,
                    "environment": [],
                    "mountPoints": [],
                    "volumesFrom": [],
                    "secrets": [
                        {
                            "name": "POSTGRES_HOST",
                            "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::"
                        },
                        {
                            "name": "POSTGRES_DB",
                            "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::"
                        },
                        {
                            "name": "POSTGRES_PASSWORD",
                            "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::"
                        }
                    ],
                    "systemControls": []
                }
            ],
            "family": "workshop2-task",
            "executionRoleArn": "arn:aws:iam::aws_account_id:role/workshop2-ecs-task-role",
            "networkMode": "awsvpc",
            "revision": 3,
            "volumes": [],
            "status": "DELETE_IN_PROGRESS",
            "requiresAttributes": [
                {
                    "name": "com.amazonaws.ecs.capability.ecr-auth"
                },
                {
                    "name": "ecs.capability.secrets.asm.environment-variables"
                },
                {
                    "name": "ecs.capability.execution-role-ecr-pull"
                },
                {
                    "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
                },
                {
                    "name": "ecs.capability.task-eni"
                }
            ],
            "placementConstraints": [],
            "compatibilities": [
                "EC2",
                "FARGATE"
            ],
            "requiresCompatibilities": [
                "EC2"
            ],
            "cpu": "256",
            "memory": "512",
            "registeredAt": "2024-03-18T20:53:25.123000+07:00",
            "deregisteredAt": "2024-03-18T22:03:14.595000+07:00",
            "registeredBy": "arn:aws:iam::aws_account_id:user/AdminUser"
        },
        {
            "taskDefinitionArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:task-definition/workshop2-task:4",
            "containerDefinitions": [
                {
                    "name": "workshop2-task",
                    "image": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest",
                    "cpu": 0,
                    "portMappings": [
                        {
                            "containerPort": 8080,
                            "hostPort": 8080,
                            "protocol": "tcp"
                        }
                    ],
                    "essential": true,
                    "environment": [],
                    "mountPoints": [],
                    "volumesFrom": [],
                    "secrets": [
                        {
                            "name": "POSTGRES_HOST",
                            "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_HOST::"
                        },
                        {
                            "name": "POSTGRES_DB",
                            "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_DB::"
                        },
                        {
                            "name": "POSTGRES_PASSWORD",
                            "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP:POSTGRES_PASSWORD::"
                        }
                    ],
                    "systemControls": []
                }
            ],
            "family": "workshop2-task",
            "executionRoleArn": "arn:aws:iam::aws_account_id:role/workshop2-ecs-task-role",
            "networkMode": "awsvpc",
            "revision": 4,
            "volumes": [],
            "status": "DELETE_IN_PROGRESS",
            "requiresAttributes": [
                {
                    "name": "com.amazonaws.ecs.capability.ecr-auth"
                },
                {
                    "name": "ecs.capability.secrets.asm.environment-variables"
                },
                {
                    "name": "ecs.capability.execution-role-ecr-pull"
                },
                {
                    "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
                },
                {
                    "name": "ecs.capability.task-eni"
                }
            ],
            "placementConstraints": [],
            "compatibilities": [
                "EC2",
                "FARGATE"
            ],
            "requiresCompatibilities": [
                "EC2"
            ],
            "cpu": "512",
            "memory": "1024",
            "registeredAt": "2024-03-18T21:57:32.371000+07:00",
            "deregisteredAt": "2024-03-18T22:03:24.508000+07:00",
            "registeredBy": "arn:aws:iam::aws_account_id:user/AdminUser"
        }
    ],
    "failures": []
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam delete-role-policy \
    --role-name $ecs_task_role_name \
    --policy-name $ecs_task_policy_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
    --role-name $ecs_task_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam delete-role --role-name $ecs_task_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ instance_ids=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ecs_autoscaling_group_name \
    --query "AutoScalingGroups[].Instances[].InstanceId" \
    --output text)
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws autoscaling delete-auto-scaling-group \
    --auto-scaling-group-name $ecs_autoscaling_group_name \
    --force-delete
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 terminate-instances --instance-ids $instance_ids
{
    "TerminatingInstances": [
        {
            "CurrentState": {
                "Code": 32,
                "Name": "shutting-down"
            },
            "InstanceId": "i-0b0f8414b1e5d9cdd",
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        }
    ]
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $
aws ec2 delete-launch-template \
    --launch-template-name $ecs_launch_template_name
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-03e5866334a2f4701",
        "LaunchTemplateName": "workshop2-ecs-launch-template",
        "CreateTime": "2024-03-18T13:27:50+00:00",
        "CreatedBy": "arn:aws:iam::aws_account_id:user/AdminUser",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs delete-cluster --cluster $ecs_cluster_name
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:cluster/workshop2-cluster",
        "clusterName": "workshop2-cluster",
        "status": "DEPROVISIONING",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [
            "workshop2-capacity-provider"
        ],
        "defaultCapacityProviderStrategy": [
            {
                "capacityProvider": "workshop2-capacity-provider",
                "weight": 1,
                "base": 0
            }
        ],
        "attachments": [
            {
                "id": "26c2636f-83ca-4e33-a83d-c3c61f772219",
                "type": "managed_draining",
                "status": "DELETING",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "workshop2-capacity-provider"
                    },
                    {
                        "name": "autoScalingLifecycleHookName",
                        "value": "ecs-managed-draining-termination-hook"
                    }
                ]
            },
            {
                "id": "4baef80a-833a-4600-993f-6fae66033391",
                "type": "as_policy",
                "status": "DELETING",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "workshop2-capacity-provider"
                    },
                    {
                        "name": "scalingPolicyName",
                        "value": "ECSManagedAutoScalingPolicy-a22627fe-49ad-4241-8019-f0b4672a646c"
                    }
                ]
            }
        ],
        "attachmentsStatus": "UPDATE_IN_PROGRESS"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecs delete-capacity-provider --capacity-provider $ecs_capacity_provider
{
    "capacityProvider": {
        "capacityProviderArn": "arn:aws:ecs:ap-southeast-1:aws_account_id:capacity-provider/workshop2-capacity-provider",
        "name": "workshop2-capacity-provider",
        "status": "INACTIVE",
        "autoScalingGroupProvider": {
            "autoScalingGroupArn": "arn:aws:autoscaling:ap-southeast-1:aws_account_id:autoScalingGroup:70132131-06ce-40c4-99ca-526a40e03d68:autoScalingGroupName/workshop2-ecs-autoscaling-group",
            "managedScaling": {
                "status": "ENABLED",
                "targetCapacity": 100,
                "minimumScalingStepSize": 1,
                "maximumScalingStepSize": 10000,
                "instanceWarmupPeriod": 300
            },
            "managedTerminationProtection": "DISABLED"
        },
        "updateStatus": "DELETE_COMPLETE",
        "tags": []
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws secretsmanager delete-secret \
    --secret-id $secret_name \
    --force-delete-without-recovery
{
    "ARN": "arn:aws:secretsmanager:ap-southeast-1:aws_account_id:secret:workshop2-sm-xRfBLP",
    "Name": "workshop2-sm",
    "DeletionDate": "2024-03-18T22:04:54.230000+07:00"
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws rds delete-db-instance \
    --db-instance-identifier $rds_name \
    --skip-final-snapshot
{
    "DBInstance": {
        "DBInstanceIdentifier": "workshop2-rds",
        "DBInstanceClass": "db.t3.micro",
        "Engine": "postgres",
        "DBInstanceStatus": "deleting",
        "MasterUsername": "postgres",
        "DBName": "workshop",
        "Endpoint": {
            "Address": "workshop2-rds.clotidgmnter.ap-southeast-1.rds.amazonaws.com",
            "Port": 5432,
            "HostedZoneId": "Z2G0U3KFCY8NZ5"
        },
        "AllocatedStorage": 20,
        "InstanceCreateTime": "2024-03-18T10:01:11.087000+00:00",
        "PreferredBackupWindow": "16:34-17:04",
        "BackupRetentionPeriod": 0,
        "DBSecurityGroups": [],
        "VpcSecurityGroups": [
            {
                "VpcSecurityGroupId": "sg-0d540c37aac8736b6",
                "Status": "active"
            }
        ],
        "DBParameterGroups": [
            {
                "DBParameterGroupName": "default.postgres16",
                "ParameterApplyStatus": "in-sync"
            }
        ],
        "AvailabilityZone": "ap-southeast-1a",
        "DBSubnetGroup": {
            "DBSubnetGroupName": "workshop2-subnet-group",
            "DBSubnetGroupDescription": "Subnet Group for Postgres RDS",
            "VpcId": "vpc-083f047268c20e7f3",
            "SubnetGroupStatus": "Complete",
            "Subnets": [
                {
                    "SubnetIdentifier": "subnet-0feb0bce83a36e8a7",
                    "SubnetAvailabilityZone": {
                        "Name": "ap-southeast-1b"
                    },
                    "SubnetOutpost": {},
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-06cbe85c62298e4c4",
                    "SubnetAvailabilityZone": {
                        "Name": "ap-southeast-1a"
                    },
                    "SubnetOutpost": {},
                    "SubnetStatus": "Active"
                }
            ]
        },
        "PreferredMaintenanceWindow": "sat:15:25-sat:15:55",
        "PendingModifiedValues": {},
        "MultiAZ": false,
        "EngineVersion": "16.1",
        "AutoMinorVersionUpgrade": true,
        "ReadReplicaDBInstanceIdentifiers": [],
        "LicenseModel": "postgresql-license",
        "OptionGroupMemberships": [
            {
                "OptionGroupName": "default:postgres-16",
                "Status": "in-sync"
            }
        ],
        "PubliclyAccessible": false,
        "StorageType": "gp2",
        "DbInstancePort": 0,
        "StorageEncrypted": false,
        "DbiResourceId": "db-OWLATTHD7AMIP7JOS3Q5V2SJLY",
        "CACertificateIdentifier": "",
        "DomainMemberships": [],
        "CopyTagsToSnapshot": false,
        "MonitoringInterval": 0,
        "DBInstanceArn": "arn:aws:rds:ap-southeast-1:aws_account_id:db:workshop2-rds",
        "IAMDatabaseAuthenticationEnabled": false,
        "PerformanceInsightsEnabled": false,
        "DeletionProtection": false,
        "AssociatedRoles": [],
        "TagList": [
            {
                "Key": "purpose",
                "Value": "workshop2"
            },
            {
                "Key": "project",
                "Value": "fcj_workshop"
            },
            {
                "Key": "author",
                "Value": "pthach_cli"
            }
        ],
        "CustomerOwnedIpEnabled": false,
        "BackupTarget": "region",
        "NetworkType": "IPV4",
        "StorageThroughput": 0
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws rds wait db-instance-deleted --db-instance-identifier $rds_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws rds delete-db-subnet-group --db-subnet-group-name $rds_subnet_group_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 delete-security-group --group-id $alb_sgr_id
aws ec2 delete-security-group --group-id $rds_sgr_id
aws ec2 delete-security-group --group-id $ecs_instance_sgr_id
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 delete-subnet --subnet-id $subnet_public_1
aws ec2 delete-subnet --subnet-id $subnet_public_2
aws ec2 delete-subnet --subnet-id $subnet_public_3
aws ec2 delete-subnet --subnet-id $subnet_private_1
aws ec2 delete-subnet --subnet-id $subnet_private_2
aws ec2 delete-subnet --subnet-id $subnet_private_3
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 delete-route-table --route-table-id $rtb_public_id
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 detach-internet-gateway \
    --internet-gateway-id $gateway_id \
    --vpc-id $vpc_id
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 delete-internet-gateway --internet-gateway-id $gateway_id
aws ec2 delete-vpc --vpc-id $vpc_id

An error occurred (DependencyViolation) when calling the DeleteVpc operation: The vpc 'vpc-083f047268c20e7f3' has dependencies and cannot be deleted.
  ubuntu@thachpham  ~/firtcloudjourney/temp    $ aws ec2 delete-route-table --route-table-id $rtb_private_id
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 delete-vpc --vpc-id $vpc_id
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecr batch-delete-image \
    --repository-name $ecr_name \
    --image-ids imageTag=latest \
    --region $region
{
    "imageIds": [
        {
            "imageDigest": "sha256:21c8e9428dd0ecc6d945ab63cfb1b63d2806d46e88dc3b9c97507765043d5eda",
            "imageTag": "latest"
        }
    ],
    "failures": []
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ecr delete-repository \
    --repository-name $ecr_name \
    --force \
    --region $region
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:ap-southeast-1:aws_account_id:repository/container-image",
        "registryId": "aws_account_id",
        "repositoryName": "container-image",
        "repositoryUri": "aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image",
        "createdAt": "2024-03-18T15:54:11.095000+07:00",
        "imageTagMutability": "MUTABLE"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker rmi $ecr_image_uri
Untagged: aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image:latest
Untagged: aws_account_id.dkr.ecr.ap-southeast-1.amazonaws.com/container-image@sha256:21c8e9428dd0ecc6d945ab63cfb1b63d2806d46e88dc3b9c97507765043d5eda
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker rmi $ecr_name
Untagged: container-image:latest
Deleted: sha256:1da6ccb43b3bb2d1bbdaa25fe6919c2008a5f02f07dfac65fc0d991602a66244
Deleted: sha256:b50f369893708d09559d6eb191411717063bffe05df76c2c979d2b5e4514330a
Deleted: sha256:98977bc63c18b8858df2ef0677b22fb85c62224e179d96fa2240a267107e4e93
Deleted: sha256:a9b50d217c0fa3e47f778dd19e26127f039c5894578450bfea085ab478d53bca
Deleted: sha256:647889d1dac0b8c4f7523baefe4764e20ff03323489460a82f65fc86f7428df3
Deleted: sha256:97b418b3d50f4544d3d321ba6c643f8454f90bc56e40935fe3195fc73c60f6b5
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 delete-key-pair --key-name $ecs_instance_key_name
rm -f $ecs_instance_key_name.pem
{
    "Return": true,
    "KeyPairId": "key-0932a36201cbda3b5"
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ docker rmi $(docker image ls -aq)
Deleted: sha256:c21e9cc9a401df9bf40f7f3e9320c57955e1b5e0d1cf5993234d78fae981a72d
Deleted: sha256:faf2625471dc6f059d95b5eac7908dad3217f06201144d9d8a408bbe6ba1c88d
Deleted: sha256:7560f71c41681fa3dd80f8a3f45e1859d7f66858d7cef96a19c116f87834c79e
Deleted: sha256:aa2782b8a9ce66fbcb0f569ee5d27835e8b69ba129d52e5ff9a0f234102ac1ed
Deleted: sha256:1bd8100a78026bf32c575a5b527611a7d901f672a1e3a396b8187ddc6f64ab81
Deleted: sha256:95341be6ca011464dea2bf3bcd28fa7e2adea2a1ca43c1b167e9b759233ed2cf
Deleted: sha256:5dd5228a0a930fbf5ee3cd3bb7ef56e1ce66ba2a1f1e0523d3a59bcd64a52759
Deleted: sha256:354a4b2c1fee1d42914e3a5d828b5fedaf6277229d42857ee399ee6dbe3eeaea
Deleted: sha256:fcc53215f29ee346096da45951cdec39655c86e19fec150187e3bc0af63a737c
Deleted: sha256:ddd006abccac5dc0cfabe857443231914c8989f41631aa7067f5f98fd837c8ac
Untagged: maven:3.9.6-eclipse-temurin-17-alpine
Untagged: maven@sha256:5c3abd43b7e977841fffda996396cf31faf3cea78ff644d16029095921a9fe05
Deleted: sha256:05532906c77ca237ffe64e22713dba56d69d32ec74425a5fbe23ed8272b99459
Deleted: sha256:902b168c9a6b6636130ea063eb7efcf71247be2955dd543ff687543b12b5d710
Deleted: sha256:373de9d8a8735afc741c490e2cc947256462c4a838e0bf54954b475f9ff38cf7
Deleted: sha256:fc107e223e3e1d48359dc18d9b6b951b03cb33c59bd5d58e08e9d78547db44f9
Deleted: sha256:94ed30d8eb5ebbaad539e69339470240855d1d265c1272c0f0aa882559e0311c
Deleted: sha256:d14f53413f04034e62e37273e249895cd16b3bfde8baa8527cee8cfc2b149002
Deleted: sha256:3bfca61d83a7fb629e02078a1fddea948fbce87a495c756c83de2e4017f9bf34
Deleted: sha256:49ab4ecdb3247890868da49344a26d1edb86f517ce9c24833ecea767e5f8cf3e
Deleted: sha256:4a1a04b724336e55df2798dec7fde0a9c634b1bc958cafea778e6082876ab6fe
Deleted: sha256:2d898185f406fc0b0219dd3b729fc4e2cca4fb2bc8c71dcbe26cd4db08f1538d
Deleted: sha256:d4fc045c9e3a848011de66f34b81f052d4f2c15a17bb196d637e526349601820
Untagged: openjdk:17-alpine
Untagged: openjdk@sha256:4b6abae565492dbe9e7a894137c966a7485154238902f2f25e9dbd9784383d81
Deleted: sha256:264c9bdce361556ba6e685e401662648358980c01151c3d977f0fdf77f7c26ab
Deleted: sha256:c886627e0a95706b0d25b7e38bc0578020aec8dde243a684a0c795e3221f3a84
Deleted: sha256:babf6cf0d64d72bad69955496ee646e0b46b9e7bae2504351c30fbc0261800a8
Deleted: sha256:72e830a4dff5f0d5225cdc0a320e85ab1ce06ea5673acfe8d83a7645cbd0e9cf
Error: No such image: 7560f71c4168
Error: No such image: 1bd8100a7802
Error: No such image: fcc53215f29e
Error: No such image: 5dd5228a0a93
  ubuntu@thachpham  ~/firtcloudjourney/temp    $ aws iam remove-role-from-instance-profile \
    --instance-profile-name $ecs_instance_role_name \
    --role-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam delete-instance-profile \
    --instance-profile-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
    --role-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
    --role-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws iam delete-role --role-name $ecs_instance_role_name
  ubuntu@thachpham  ~/firtcloudjourney/temp  $