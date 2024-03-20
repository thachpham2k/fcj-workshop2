# Muốn chạy thì xóa #??? ở giữa file đi 
echo "=========== aws cli"
aws --version
aws configure
aws configure list
echo "============ terminal config"
# project
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
echo "============================"
echo project=$project
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

echo "================2.3 iam"
ecs_instance_role_name=$project-ecs-instance-role
echo ecs_instance_role_name=$ecs_instance_role_name
# Create EC2 Role
aws iam create-role \
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
    
aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
    --role-name $ecs_instance_role_name

aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
    --role-name $ecs_instance_role_name

aws iam create-instance-profile \
    --instance-profile-name $ecs_instance_role_name

aws iam add-role-to-instance-profile \
    --instance-profile-name $ecs_instance_role_name \
    --role-name $ecs_instance_role_name

ecs_instance_profile_arn=$(aws iam get-instance-profile \
    --instance-profile-name $ecs_instance_role_name \
    --output text \
    --query 'InstanceProfile.Arn')

echo ecs_instance_profile_arn=$ecs_instance_profile_arn

echo "================ keypair"
ecs_instance_key_name=$project-keypair
echo ecs_instance_key_name=$ecs_instance_key_name
echo region=$region
ls
# Create Keypair
aws ec2 create-key-pair \
    --key-name $ecs_instance_key_name \
    --region $region \
    --tag-specifications `echo 'ResourceType=key-pair,Tags=['$tagspec` \
    --query 'KeyMaterial' \
    --output text > ./$ecs_instance_key_name.pem

ls

echo "==========ecr"
ecr_name=$docker_image_name
echo ecr_name=$ecr_name
# Create new ecr repository
aws ecr create-repository \
    --repository-name $ecr_name \
    --region $region \
    --tags "$tags"

aws ecr get-login-password \
    --region $region \
    | docker login \
    --username AWS \
    --password-stdin $aws_account_id.dkr.ecr.$region.amazonaws.com

cat ~/.docker/config.json

cd ../workshop2
docker images --filter reference=$ecr_name
docker build -t $ecr_name .
docker images --filter reference=$ecr_name
cd ../temp

docker tag $ecr_name:latest $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name
docker image ls
docker push $aws_account_id.dkr.ecr.$region.amazonaws.com/$ecr_name

echo "===========network"
vpc_name=$project-vpc
vpc_cidr=10.1.0.0/16
echo vpc_name=$vpc_name
echo vpc_cidr=$vpc_cidr
# Create VPC and Enable dns-hostname feature in vpc
vpc_id=$(aws ec2 create-vpc \
    --cidr-block $vpc_cidr \
    --region $region \
    --tag-specifications `echo 'ResourceType=vpc,Tags=[{Key=Name,Value='$vpc_name'},'$tagspec` \
    --output text \
    --query 'Vpc.VpcId')

aws ec2 modify-vpc-attribute \
    --vpc-id $vpc_id \
    --enable-dns-hostnames '{"Value": true}'

echo vpc_id=$vpc_id

pubsubnet1_name=$project-pubsubnet-$az_01
pubsubnet2_name=$project-pubsubnet-$az_02
pubsubnet3_name=$project-pubsubnet-$az_03
for (( i=1; i<=3; i++ ))
do
    eval pubsubnet${i}_cidr=\"10.1.$((($i-1)*16)).0/20\"
done

echo pubsubnet1_name=$pubsubnet1_name
echo pubsubnet2_name=$pubsubnet2_name
echo pubsubnet3_name=$pubsubnet3_name
echo pubsubnet1_cidr=$pubsubnet1_cidr
echo pubsubnet2_cidr=$pubsubnet2_cidr
echo pubsubnet3_cidr=$pubsubnet3_cidr
# Create subnet
subnet_public_1=$(aws ec2 create-subnet \
    --availability-zone $az_01 \
    --cidr-block $pubsubnet1_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet1_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

subnet_public_2=$(aws ec2 create-subnet \
    --availability-zone $az_02 \
    --cidr-block $pubsubnet2_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet2_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

subnet_public_3=$(aws ec2 create-subnet \
    --availability-zone $az_03 \
    --cidr-block $pubsubnet3_cidr \
    --tag-specifications `echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$pubsubnet3_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.Subnet.SubnetId')

echo subnet_public_1=$subnet_public_1
echo subnet_public_2=$subnet_public_2
echo subnet_public_3=$subnet_public_3

prisubnet1_name=$project-prisubnet-$az_01
prisubnet2_name=$project-prisubnet-$az_02
prisubnet3_name=$project-prisubnet-$az_03
for (( i=1; i<=3; i++ ))
do
    eval prisubnet${i}_cidr=\"10.1.$((($i+3)*16)).0/20\"
done

echo prisubnet1_name=$prisubnet1_name
echo prisubnet2_name=$prisubnet2_name
echo prisubnet3_name=$prisubnet3_name
echo prisubnet1_cidr=$prisubnet1_cidr
echo prisubnet2_cidr=$prisubnet2_cidr
echo prisubnet3_cidr=$prisubnet3_cidr
# Create subnet
subnet_private_1=$(aws ec2 create-subnet \
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

echo subnet_private_1=$subnet_private_1
echo subnet_private_2=$subnet_private_2
echo subnet_private_3=$subnet_private_3

igw_name=$project-igw
echo igw_name=$igw_name
# Create Internet Gateway
gateway_id=$(aws ec2 create-internet-gateway \
    --region $region \
    --tag-specifications `echo 'ResourceType=internet-gateway,Tags=[{Key=Name,Value='$igw_name'},'$tagspec` \
    --output text \
    --query 'InternetGateway.InternetGatewayId')

aws ec2 attach-internet-gateway \
    --vpc-id $vpc_id \
    --internet-gateway-id $gateway_id

echo gateway_id=$gateway_id

rtb_public_name=$project-rtb
echo rtb_public_name=$rtb_public_name
# Create Route table
rtb_public_id=$(aws ec2 create-route-table \
    --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_public_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')

aws ec2 create-route \
    --route-table-id $rtb_public_id \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $gateway_id

# Associate each public subnet with the public route table
aws ec2 associate-route-table \
    --subnet-id $subnet_public_1 \
    --route-table-id $rtb_public_id

aws ec2 associate-route-table \
    --subnet-id $subnet_public_2 \
    --route-table-id $rtb_public_id

aws ec2 associate-route-table \
    --subnet-id $subnet_public_3 \
    --route-table-id $rtb_public_id

echo rtb_public_id=$rtb_public_id

rtb_private_name=$project-rtb-private
echo rtb_private_name=$rtb_private_name
# Tạo Route table
rtb_private_id=$(aws ec2 create-route-table \
    --tag-specifications `echo 'ResourceType=route-table,Tags=[{Key=Name,Value='$rtb_private_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.RouteTable.RouteTableId')

# Gán mỗi Public Subnet với the Route Table
aws ec2 associate-route-table \
    --subnet-id $subnet_private_1 \
    --route-table-id $rtb_private_id

aws ec2 associate-route-table \
    --subnet-id $subnet_private_2 \
    --route-table-id $rtb_private_id

aws ec2 associate-route-table \
    --subnet-id $subnet_private_3 \
    --route-table-id $rtb_private_id

echo rtb_private_id=$rtb_private_id

echo "============== security group"
ecs_instance_sgr_name=$project-ecs-sgr
echo ecs_instance_sgr_name=$ecs_instance_sgr_name
# Create Security Group
ecs_instance_sgr_id=$(aws ec2 create-security-group \
    --group-name $ecs_instance_sgr_name \
    --description "Security group for EC2 in ECS" \
    --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$ecs_instance_sgr_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.GroupId')

aws ec2 authorize-security-group-ingress \
   --group-id $ecs_instance_sgr_id \
   --protocol tcp \
   --port 8080 \
   --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
   --group-id $ecs_instance_sgr_id \
   --protocol tcp \
   --port 22 \
   --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
   --group-id $ecs_instance_sgr_id \
   --protocol tcp \
   --port 443 \
   --cidr 0.0.0.0/0

echo ecs_instance_sgr_id=$ecs_instance_sgr_id

rds_sgr_name=$project-rds-sgr
echo rds_sgr_name=$rds_sgr_name
# Create Security Group
rds_sgr_id=$(aws ec2 create-security-group \
    --group-name $rds_sgr_name  \
    --description "Security group for RDS" \
    --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$rds_sgr_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.GroupId')

aws ec2 authorize-security-group-ingress \
    --group-id $rds_sgr_id \
    --protocol tcp \
    --port 5432 \
     --source-group $ecs_instance_sgr_id

echo rds_sgr_id=$rds_sgr_id

alb_sgr_name=$project-alb-sgr
echo alb_sgr_name=$alb_sgr_name
echo vpc_id=$vpc_id
# Create security group
alb_sgr_id=$(aws ec2 create-security-group \
    --group-name $alb_sgr_name \
    --description "Security group for ALB" \
    --tag-specifications `echo 'ResourceType=security-group,Tags=[{Key=Name,Value='$alb_sgr_name'},'$tagspec` \
    --vpc-id $vpc_id | jq -r '.GroupId')

aws ec2 authorize-security-group-ingress \
   --group-id $alb_sgr_id \
   --protocol tcp \
   --port 22 \
   --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
   --group-id $alb_sgr_id \
   --protocol tcp \
   --port 80 \
   --cidr 0.0.0.0/0

echo alb_sgr_id=$alb_sgr_id

echo "============== VPC Endpoint"

ecs_ec2_subnet_id=$subnet_private_1
vpc_endpoint_s3=$project-vpce-s3
vpc_endpoint_ecr_dkr=$project-vpce-ecr-dkr
vpc_endpoint_ecr_api=$project-vpce-ecr-api
vpc_endpoint_ecs=$project-vpce-ecs
vpc_endpoint_ecs_agent=$project-vpce-ecs-agent
vpc_endpoint_ecs_telemetry=$project-vpce-ecs-telemetry
vpc_endpoint_ssm=$project-vpce-ssm
vpc_endpoint_secretsmanager=$project-vpce-secretsmanager

echo vpc_endpoint_s3=$vpc_endpoint_s3
echo vpc_endpoint_ecr_dkr=$vpc_endpoint_ecr_dkr
echo vpc_endpoint_ecr_api=$vpc_endpoint_ecr_api
echo vpc_endpoint_ecs=$vpc_endpoint_ecs
echo vpc_endpoint_ecs_agent=$vpc_endpoint_ecs_agent
echo vpc_endpoint_ecs_telemetry=$vpc_endpoint_ecs_telemetry
echo vpc_endpoint_ssm=$vpc_endpoint_ssm
echo vpc_endpoint_secretsmanager=$vpc_endpoint_secretsmanager


aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --service-name com.amazonaws.$region.s3 \
    --route-table-ids $rtb_private_id

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecr.dkr \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecr_dkr'},'$tagspec` 

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecr.api \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecr_api'},'$tagspec`

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecs \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecs'},'$tagspec`

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecs-agent \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecs_agent'},'$tagspec`

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecs-telemetry \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecs_telemetry'},'$tagspec`

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ssm \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ssm'},'$tagspec`

aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.secretsmanager  \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_secretsmanager'},'$tagspec`

echo "============= RDS"
rds_subnet_group_name=$project-subnet-group
rds_subnet_group_descript="Subnet Group for Postgres RDS"
rds_subnet1_id=$subnet_private_1
rds_subnet2_id=$subnet_private_2 
echo rds_subnet_group_name=$rds_subnet_group_name
echo rds_subnet_group_descript=$rds_subnet_group_descript
echo rds_subnet1_id=$rds_subnet1_id
echo rds_subnet2_id=$rds_subnet2_id
# Create Subnet group
aws rds create-db-subnet-group \
    --db-subnet-group-name $rds_subnet_group_name \
    --db-subnet-group-description "$rds_subnet_group_descript" \
    --subnet-ids $rds_subnet1_id $rds_subnet2_id \
    --tags "$tags"

rds_name=$project-rds
rds_db_name="workshop"
rds_db_username="postgres"
rds_db_password="postgres"
echo rds_name=$rds_name
echo rds_db_name=$rds_db_name
echo rds_db_username=$rds_db_username
echo rds_db_password=$rds_db_password
echo az_01=$az_01
echo rds_subnet_group_name=$rds_subnet_group_name
echo rds_sgr_id=$rds_sgr_id
# Create RDS
aws rds create-db-instance \
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

aws rds wait db-instance-available \
    --db-instance-identifier $rds_name
# Get RDS information
rds_address=$(aws rds describe-db-instances \
    --db-instance-identifier $rds_name \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)

echo rds_address=$rds_address

echo "=========== secretsmanager" 
secret_name=$project-sm
secret_string=$(echo "{\"POSTGRES_HOST\":\"$rds_address\",\"POSTGRES_PORT\":\"5432\",\"POSTGRES_DB\":\"$rds_db_name\",\"POSTGRES_USERNAME\":\"$rds_db_username\",\"POSTGRES_PASSWORD\":\"$rds_db_password\"}")
echo secret_name=$secret_name
echo secret_string=$secret_string
# Create SecretManager
aws secretsmanager create-secret \
    --name $secret_name \
    --description "To save database information" \
    --tags "$tags" \
    --secret-string $secret_string
# Get ARN of AWS secret manager
secret_arn=$(aws secretsmanager describe-secret --secret-id $secret_name --query 'ARN' --output text)

echo secret_arn=$secret_arn

echo "=========7. alb"
alb_name=$project-alb
alb_tgr_name=$project-tgr
alb_vpc_id=$vpc_id
alb_subnet1_id=$subnet_public_1
alb_subnet2_id=$subnet_public_2
echo alb_sgr_name=$alb_sgr_name
echo alb_name=$alb_name
echo alb_tgr_name=$alb_tgr_name
echo alb_vpc_id=$alb_vpc_id
echo alb_subnet1_id=$alb_subnet1_id
echo alb_subnet2_id=$alb_subnet2_id
echo alb_sgr_id=$alb_sgr_id
# Create ALB
alb_arn=$(aws elbv2 create-load-balancer \
    --name $alb_name  \
    --subnets $alb_subnet1_id $alb_subnet2_id \
    --security-groups $alb_sgr_id \
    --tags "$tags" \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

echo alb_arn=$alb_arn

alb_tgr_arn=$(aws elbv2 create-target-group \
    --name $alb_tgr_name \
    --protocol HTTP \
    --target-type ip \
    --health-check-path "/api/product" \
    --port 8080 \
    --vpc-id $alb_vpc_id \
    --tags "$tags" \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

echo alb_tgr_arn=$alb_tgr_arn

alb_listener_arn=$(aws elbv2 create-listener \
  --load-balancer-arn $alb_arn \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=$alb_tgr_arn \
  --query 'Listeners[0].ListenerArn' \
  --output text)

echo alb_listener_arn$alb_listener_arn

echo "============ECS cluster"
ecs_cluster_name=$project-cluster
echo ecs_cluster_name=$ecs_cluster_name
# Create ECS Cluster
aws ecs create-cluster \
    --cluster-name $ecs_cluster_name \
    --region $region \
    --tags "$tags2"

# Check ECS Cluster created correctly
aws ecs list-clusters

echo "========ECS Capacity"
# Get ECS AMI ID
ecs_instance_ami_id=$(aws ssm get-parameters \
    --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
    --region $region | jq -r '.Parameters[0].Value | fromjson.image_id')

echo ecs_instance_ami_id=$ecs_instance_ami_id

ecs_instance_type=t3.medium
ecs_instance_subnet_id=$subnet_public_1
echo ecs_instance_ami_id=$ecs_instance_ami_id
echo ecs_instance_type=$ecs_instance_type
echo ecs_instance_profile_arn=$ecs_instance_profile_arn
echo ecs_instance_sgr_id=$ecs_instance_sgr_id
echo ecs_instance_subnet_id=$ecs_instance_subnet_id
echo ecs_instance_key_name=$ecs_instance_key_name
ls
# Create Launch template
cat <<EOF | tee ecs-launch-template.json
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

"???

ls
cat ecs-launch-template.json

ecs_launch_template_name=$project-ecs-launch-template
echo ecs_launch_template_name=$ecs_launch_template_name

aws ec2 create-launch-template \
    --launch-template-name $ecs_launch_template_name \
    --launch-template-data file://ecs-launch-template.json

ecs_instance_name=$project-ecs-instance
ecs_autoscaling_group_name=$project-ecs-autoscaling-group
echo ecs_instance_name=$ecs_instance_name
echo ecs_autoscaling_group_name=$ecs_autoscaling_group_name
echo ecs_launch_template_name=$ecs_launch_template_name

# create Autoscaling group
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name $ecs_autoscaling_group_name \
    --launch-template "$(echo "{\"LaunchTemplateName\":\"$ecs_launch_template_name\"}")" \
    --min-size 1 \
    --max-size 3 \
    --desired-capacity 1 \
    --tags "$(echo $tags | jq -c '. + [{"Key":"Name","Value":"'"$ecs_instance_name"'"}]')"

ecs_autoscaling_group_arn=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ecs_autoscaling_group_name \
    | jq .AutoScalingGroups[0].AutoScalingGroupARN)

echo ecs_autoscaling_group_arn=$ecs_autoscaling_group_arn

aws ecs list-container-instances --cluster $ecs_cluster_name

ecs_capacity_provider=$project-capacity-provider
echo ecs_capacity_provider=$ecs_capacity_provider

aws ecs create-capacity-provider \
    --name $ecs_capacity_provider \
    --auto-scaling-group-provider `echo "autoScalingGroupArn=$ecs_autoscaling_group_arn,managedScaling={status=ENABLED,targetCapacity=100},managedTerminationProtection=DISABLED"`

aws ecs put-cluster-capacity-providers \
    --cluster $ecs_cluster_name \
    --capacity-providers $ecs_capacity_provider \
    --default-capacity-provider-strategy capacityProvider=$ecs_capacity_provider,weight=1

echo "========== task definition"
echo secret_arn=$secret_arn
# Create Task Definition role
ecs_task_role_name=$project-ecs-task-role
ecs_task_policy_name=${project}_ecs_task_policy
ecs_task_name=$project-task
ecs_task_uri=$ecr_image_uri
echo ecs_task_role_name=$ecs_task_role_name
echo ecs_task_policy_name=$ecs_task_policy_name
echo ecs_task_name=$ecs_task_name
echo ecs_task_uri=$ecs_task_uri

# Create EC2 Role
ecs_task_role_arn=$(aws iam create-role \
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

echo ecs_task_role_arn=$ecs_task_role_arn

cat <<EOF | tee ecs-task-role.json
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

ls
cat ecs-task-role.json

aws iam put-role-policy \
    --role-name $ecs_task_role_name \
    --policy-name $ecs_task_policy_name \
    --policy-document file://ecs-task-role.json

aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
    --role-name $ecs_task_role_name

cat <<EOF | tee task-definition.json
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
ls
cat task-definition.json
# Create task-definition
ecs_task_definition=$(aws ecs register-task-definition \
    --family $ecs_task_name \
    --network-mode awsvpc \
    --requires-compatibilities EC2 \
    --cpu "512" \
    --memory "1024" \
    --execution-role-arn "$ecs_task_role_arn" \
    --tags "$tags2" \
    --container-definitions "`jq -c . task-definition.json`" )

# Check ECS task definition created correctly
aws ecs list-task-definitions

ecs_task_arn=$(aws ecs describe-task-definition \
    --task-definition $ecs_task_name \
    --query "taskDefinition.taskDefinitionArn" \
    --output text)

echo ecs_task_arn=$ecs_task_arn

echo "=================== service"
ecs_service_name=$project-service
echo ecs_cluster_name=$ecs_cluster_name
echo ecs_service_name=$ecs_service_name
echo ecs_task_arn=$ecs_task_arn
# Tạo Service
aws ecs create-service \
   --cluster $ecs_cluster_name \
   --service-name $ecs_service_name \
   --task-definition $ecs_task_arn \
   --desired-count 1 \
   --network-configuration "awsvpcConfiguration={subnets=[$ecs_instance_subnet_id],securityGroups=[$ecs_instance_sgr_id]}" 

echo ecs_cluster_name=$ecs_cluster_name
echo ecs_service_name=$ecs_service_name
echo ecs_task_definition=$ecs_task_definition

aws ecs update-service --cluster $ecs_cluster_name \
    --service $ecs_service_name \
    --desired-count 1 \
    --load-balancers targetGroupArn=$alb_tgr_arn,containerName=`echo $ecs_task_definition | jq -r '.taskDefinition.containerDefinitions[0].name'`,containerPort=8080

aws elbv2 describe-target-health --target-group-arn $alb_tgr_arn

echo "Finally"

aws elbv2 describe-load-balancers \
    --load-balancer-arns $alb_arn \
    --query 'LoadBalancers[0].DNSName' \
    --output text

