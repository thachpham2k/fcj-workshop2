
## EC2 AMI
```shell
# Get ECS AMI ID
# [get ecs ami](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/retrieve-ecs-optimized_AMI.html)
ecs_ec2_ami_id=$(aws ssm get-parameters \
    --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
    --region $region | jq -r '.Parameters[0].Value | fromjson.image_id')

echo $ecs_ec2_ami_id
```

## Create auto scaling group
```shell
ecs_ec2_name=$project-ecs-ec2
ecs_ec2_template_name=$project-ecs-ec2-template
ecs_ec2_autoscale_name=$project-ecs-ec2-autoscale
ecs_ec2_instancetype=t3.medium
ecs_ec2_subnet_id=$subnet_private_1

# Create Launch template
cat <<EOF | tee ecs-ec2-launch-template.json
{
    "ImageId": "$ecs_ec2_ami_id",
    "InstanceType": "$ecs_ec2_instancetype",
    "IamInstanceProfile": {
        "Arn": "$ecs_ec2_instanceprofile_arn"
    },
    "NetworkInterfaces": [{
        "DeviceIndex": 0,
        "AssociatePublicIpAddress": true,
        "Groups": ["$ecs_ec2_sgr_id"],
        "SubnetId": "$ecs_ec2_subnet_id"
    }],
    "KeyName": "$ecs_ec2_key_name",
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
```


```shell
# 
aws ec2 create-launch-template \
    --launch-template-name $ecs_ec2_template_name \
    --launch-template-data file://ecs-ec2-launch-template.json

# create Autoscaling group
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name $ecs_ec2_autoscale_name \
    --launch-template "$(echo "{\"LaunchTemplateName\":\"$ecs_ec2_template_name\"}")" \
    --min-size 1 \
    --max-size 3 \
    --desired-capacity 1 \
    --tags "$(echo '[{"Key":"Name","Value":"'"${ecs_ec2_name}"'"}]')"

ecs_ec2_autoscaling_arn=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ecs_ec2_autoscale_name \
    | jq .AutoScalingGroups[0].AutoScalingGroupARN)
```
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)

```shell
ecs_capacity_provider=$project-capacity-provider

aws ecs create-capacity-provider \
    --name $ecs_capacity_provider \
    --auto-scaling-group-provider `echo "autoScalingGroupArn=$ecs_ec2_autoscaling_arn,managedScaling={status=ENABLED,targetCapacity=100},managedTerminationProtection=DISABLED"`

aws ecs put-cluster-capacity-providers \
    --cluster $ecs_cluster_name \
    --capacity-providers $ecs_capacity_provider \
    --default-capacity-provider-strategy capacityProvider=$ecs_capacity_provider,weight=1
```

Giải thích capacity provider với autoscaling group
https://stackoverflow.com/questions/67398134/whats-the-difference-on-using-a-ecs-capacity-provider-and-using-automatic-scalin

