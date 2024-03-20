  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo "============== VPC Endpoint"
============== VPC Endpoint
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ ecs_ec2_subnet_id=$subnet_private_1
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ vpc_endpoint_s3=$project-vpce-s3
vpc_endpoint_ecr_dkr=$project-vpce-ecr-dkr
vpc_endpoint_ecr_api=$project-vpce-ecr-api
vpc_endpoint_ecs=$project-vpce-ecs
vpc_endpoint_ecs_agent=$project-vpce-ecs-agent
vpc_endpoint_ecs_telemetry=$project-vpce-ecs-telemetry
vpc_endpoint_ssm=$project-vpce-ssm
vpc_endpoint_secretsmanager=$project-vpce-secretsmanager
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ echo vpc_endpoint_s3=$vpc_endpoint_s3
echo vpc_endpoint_ecr_dkr=$vpc_endpoint_ecr_dkr
echo vpc_endpoint_ecr_api=$vpc_endpoint_ecr_api
echo vpc_endpoint_ecs=$vpc_endpoint_ecs
echo vpc_endpoint_ecs_agent=$vpc_endpoint_ecs_agent
echo vpc_endpoint_ecs_telemetry=$vpc_endpoint_ecs_telemetry
echo vpc_endpoint_ssm=$vpc_endpoint_ssm
echo vpc_endpoint_secretsmanager=$vpc_endpoint_secretsmanager
vpc_endpoint_s3=workshop2-vpce-s3
vpc_endpoint_ecr_dkr=workshop2-vpce-ecr-dkr
vpc_endpoint_ecr_api=workshop2-vpce-ecr-api
vpc_endpoint_ecs=workshop2-vpce-ecs
vpc_endpoint_ecs_agent=workshop2-vpce-ecs-agent
vpc_endpoint_ecs_telemetry=workshop2-vpce-ecs-telemetry
vpc_endpoint_ssm=workshop2-vpce-ssm
vpc_endpoint_secretsmanager=workshop2-vpce-secretsmanager
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --service-name com.amazonaws.$region.s3 \
    --route-table-ids $rtb_private_id
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-0bbb78df0e093879a",
        "VpcEndpointType": "Gateway",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.s3",
        "State": "available",
        "PolicyDocument": "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"*\",\"Resource\":\"*\"}]}",
        "RouteTableIds": [
            "rtb-0d38e86b97503bcde"
        ],
        "SubnetIds": [],
        "Groups": [],
        "PrivateDnsEnabled": false,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [],
        "DnsEntries": [],
        "CreationTimestamp": "2024-03-18T09:51:05+00:00",
        "OwnerId": "914706199417"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecr.dkr \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecr_dkr'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-0ef4d50cac0e0ba43",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.ecr.dkr",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-055856d581fa1181f"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-0ef4d50cac0e0ba43-m0lmvmck.dkr.ecr.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-0ef4d50cac0e0ba43-m0lmvmck-ap-southeast-1a.dkr.ecr.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "dkr.ecr.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            },
            {
                "DnsName": "*.dkr.ecr.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:51:12.936000+00:00",
        "Tags": [
            {
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecr.api \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecr_api'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-0c590a7d7dba52eca",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.ecr.api",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-0ba06b63f9c4d37ca"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-0c590a7d7dba52eca-chu7w7tj.api.ecr.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-0c590a7d7dba52eca-chu7w7tj-ap-southeast-1a.api.ecr.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "api.ecr.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:51:25.924000+00:00",
        "Tags": [
            {
                "Key": "Name",
                "Value": "workshop2-vpce-ecr-api"
            },
            {
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecs \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecs'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-0991b9934c1e57c3f",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.ecs",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-0fd684a325ea16e52"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-0991b9934c1e57c3f-ja5lmv7r.ecs.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-0991b9934c1e57c3f-ja5lmv7r-ap-southeast-1a.ecs.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "ecs.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:51:41.481000+00:00",
        "Tags": [
            {
                "Key": "Name",
                "Value": "workshop2-vpce-ecs"
            },
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
        "OwnerId": "914706199417"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecs-agent \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecs_agent'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-0c9b8a965f4b139ee",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.ecs-agent",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-0535be0c6f166b47f"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-0c9b8a965f4b139ee-uk6p4k05.ecs-a.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-0c9b8a965f4b139ee-uk6p4k05-ap-southeast-1a.ecs-a.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "ecs-a.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:51:52.208000+00:00",
        "Tags": [
            {
                "Key": "Name",
                "Value": "workshop2-vpce-ecs-agent"
            },
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
        "OwnerId": "914706199417"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ecs-telemetry \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ecs_telemetry'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-0139f176a1a7e9eed",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.ecs-telemetry",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-0d52f2377f83ccc4c"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-0139f176a1a7e9eed-bcoipb30.ecs-t.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-0139f176a1a7e9eed-bcoipb30-ap-southeast-1a.ecs-t.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "ecs-t.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:52:02.332000+00:00",
        "Tags": [
            {
                "Key": "Name",
                "Value": "workshop2-vpce-ecs-telemetry"
            },
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
        "OwnerId": "914706199417"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.ssm \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_ssm'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-09a72750ede9badc6",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.ssm",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-0d1b8ad841acbb024"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-09a72750ede9badc6-1bz0xi6e.ssm.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-09a72750ede9badc6-1bz0xi6e-ap-southeast-1a.ssm.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "ssm.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:52:15.599000+00:00",
        "Tags": [
            {
                "Key": "Name",
                "Value": "workshop2-vpce-ssm"
            },
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
        "OwnerId": "914706199417"
    }
}
  ubuntu@thachpham  ~/firtcloudjourney/temp  $ aws ec2 create-vpc-endpoint \
    --vpc-id $vpc_id \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.$region.secretsmanager  \
    --subnet-ids $ecs_ec2_subnet_id \
    --security-group-id $ecs_ec2_sgr_id \
    --tag-specifications `echo 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value='$vpc_endpoint_secretsmanager'},'$tagspec`
{
    "VpcEndpoint": {
        "VpcEndpointId": "vpce-072690f01822817d9",
        "VpcEndpointType": "Interface",
        "VpcId": "vpc-083f047268c20e7f3",
        "ServiceName": "com.amazonaws.ap-southeast-1.secretsmanager",
        "State": "pending",
        "RouteTableIds": [],
        "SubnetIds": [
            "subnet-06cbe85c62298e4c4"
        ],
        "Groups": [
            {
                "GroupId": "sg-0e80a7d3931f3ac20",
                "GroupName": "default"
            }
        ],
        "IpAddressType": "ipv4",
        "DnsOptions": {
            "DnsRecordIpType": "ipv4"
        },
        "PrivateDnsEnabled": true,
        "RequesterManaged": false,
        "NetworkInterfaceIds": [
            "eni-00bdbe1021c695a10"
        ],
        "DnsEntries": [
            {
                "DnsName": "vpce-072690f01822817d9-ic560aeg.secretsmanager.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "vpce-072690f01822817d9-ic560aeg-ap-southeast-1a.secretsmanager.ap-southeast-1.vpce.amazonaws.com",
                "HostedZoneId": "Z18LLCSTV4NVNL"
            },
            {
                "DnsName": "secretsmanager.ap-southeast-1.amazonaws.com",
                "HostedZoneId": "ZONEIDPENDING"
            }
        ],
        "CreationTimestamp": "2024-03-18T09:52:27.319000+00:00",
        "Tags": [
            {
                "Key": "Name",
                "Value": "workshop2-vpce-secretsmanager"
            },
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
        "OwnerId": "914706199417"
    }
}