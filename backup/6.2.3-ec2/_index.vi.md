
> 👉You can using create Auto Scaling Group instead of create EC2 or only EC2 or both.  
> 
## Create EC2
```shell
# ecs_ec2_subnet_id=$subnet_public_1
ecs_ec2_subnet_id=$subnet_private_1
ecs_ec2_name=$project-ecs-ec2
# Create EC2
cat <<EOF | tee ecs-ec2-userdata.txt
#!/bin/bash
echo ECS_CLUSTER=`echo -n $ecs_cluster_name` >> /etc/ecs/ecs.config
EOF

ecs_ec2_id=$(aws ec2 run-instances \
    --image-id $ecs_ec2_ami_id \
    --count 1 \
    --instance-type t3.medium \
    --subnet-id $ecs_ec2_subnet_id \
    --key-name $ecs_ec2_key_name \
    --security-group-ids $ecs_ec2_sgr_id \
    --associate-public-ip-address \
    --user-data  file://ecs-ec2-userdata.txt \
    --tag-specifications `echo "ResourceType=instance,Tags=[{Key=Name,Value='$ecs_ec2_name'},"$tagspec` | jq -r '.Instances[0].InstanceId')

aws ec2 wait instance-running --instance-ids $ecs_ec2_id

aws ec2 associate-iam-instance-profile \
    --instance-id $ecs_ec2_id \
    --iam-instance-profile Name=$ecs_ec2_role_name

echo $ecs_ec2_id   
```
</details>

![alt text](image-9.png)

<details>