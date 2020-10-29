#!/bin/bash


aws ec2 describe-instances --query 'Reservations[*].Instances[*].{InstanceName:Tags[?Key==`Name`] | [0].Value,PublicIPAddress:PublicIpAddress,ElasticIPAddress:ElasticIpAddress,InstanceID:InstanceId,InstanceType:InstanceType,InstanceState:State.Name,SubnetID:SubnetId,VPCID:VpcId}' --filters Name=instance-state-name,Values=running --output table --region us-east-1 
