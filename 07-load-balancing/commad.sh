#!/usr/bin/env bash
aws ssm get-parameters-by-path --path /aws/service/ami-amazon-linux-latest --query "Parameters[].Name" --profile temp
aws ssm get-parameters-by-path --path /aws/service/ami-amazon-linux-latest --profile temp

aws cloudformation create-stack --stack-name jahidul-06-uto-sacling-lab-lab \
                                --template-body file://auto_sacling_lab_6_1_1.yaml \
                                --profile temp
aws autoscaling create-auto-scaling-group \
--auto-scaling-group-name jislam-asg \
--instance-id i-0b35dedf2e4daf880 \
--min-size 1 \
--max-size 1 \
--region us-east-1 \
--profile temp

aws autoscaling update-auto-scaling-group \
--auto-scaling-group-name jislam-asg \
--min-size 1 \
--max-size 1 \
--profile temp

aws cloudformation create-stack --stack-name jahidul-06-auto-sacling-lab-lab \
                                --template-body file://auto_sacling_lab_6_1_1.yaml \
                                --profile temp

aws cloudformation create-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-1-2 \
                                --template-body file://auto_sacling_lab_6_1_2.yaml \
                                --profile temp

aws cloudformation update-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-1-2 \
                                --template-body file://auto_sacling_lab_6_1_2.yaml \
                                --profile temp
aws cloudformation update-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-1-2 \
                                --template-body file://auto_sacling_lab_6_1_4.yaml \
                                --profile temp
aws cloudformation create-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-2 \
                                --template-body file://auto_sacling_lab_6_1_5.yaml \
                                --profile temp

aws cloudformation describe-stack-resources \
--stack-name jahidul-06-auto-sacling-lab-lab-6-2 \
--profile temp

aws cloudformation describe-stack-resources \
--stack-name jahidul-06-auto-sacling-lab-lab-6-2 \
--output text \
--query 'StackResources[0].PhysicalResourceId' \
--profile temp

aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --profile temp

aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --output text \
    --query 'AutoScalingGroups[0].Instances[0].InstanceId' \
    --profile temp

aws ec2 terminate-instances \
        --instance-ids i-03fb4ae4bf97bf0d4 \
        --profile temp

aws cloudformation update-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-2 \
                                --template-body file://auto_sacling_lab_6_2_2.yaml \
                                --profile temp

aws autoscaling set-instance-health \
    --instance-id i-073898ed7e4b2dac2 \
    --health-status Unhealthy \
    --profile temp

aws autoscaling enter-standby \
    --instance-ids i-0d1f05f17aec35950 \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --should-decrement-desired-capacity \
    --profile temp

aws autoscaling describe-auto-scaling-instances --instance-ids i-0d1f05f17aec35950 --profile temp
# Suspend Launch
aws autoscaling suspend-processes --auto-scaling-group-name jislam-ec2-asg-by-cf-2 --scaling-processes Launch --profile temp
# One instance in standby mode
aws autoscaling enter-standby \
    --instance-ids i-0390bc79a2a702413 \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --should-decrement-desired-capacity \
    --profile temp
# Exit Standby (While Launch is disable)
aws autoscaling exit-standby \
    --instance-ids i-0390bc79a2a702413 \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --profile temp
# Response received: Cannot move instances out of Standby for AutoScalingGroup jislam-ec2-asg-by-cf-2 while the Launch process is suspended
# Going to resume the Launch and try putting instance back in service
aws autoscaling resume-processes \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --scaling-processes Launch \
    --profile temp
aws autoscaling exit-standby \
    --instance-ids i-0390bc79a2a702413 \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --profile temp

aws autoscaling exit-standby \
    --instance-ids i-0d1f05f17aec35950 \
    --auto-scaling-group-name jislam-ec2-asg-by-cf-2 \
    --profile temp
# Stress package in debian
sudo apt-get update
sudo apt-get install stress
sudo stress --cpu 8 -v --timeout 120s


aws cloudformation update-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-2 \
                                --template-body file://auto_sacling_lab_6_3_2.yaml \
                                --profile temp

ssh -i "mdjahidul-key-pair.cer" admin@ec2-54-204-226-220.compute-1.amazonaws.com

aws cloudformation create-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-3 \
                                --template-body file://auto_sacling_lab_6_3_3.yaml \
                                --profile temp

aws cloudformation update-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-3 \
                                --template-body file://auto_sacling_lab_6_3_4.yaml \
                                --profile temp

aws cloudformation create-stack --stack-name jahidul-07-load-balancing-lab-7 \
                                --template-body file://lb_lab_7_1_1.yaml \
                                --profile temp
aws cloudformation update-stack --stack-name jahidul-07-load-balancing-lab-7 \
                                --template-body file://lb_lab_7_1_1.yaml \
                                --profile temp
aws ec2 create-key-pair \
    --key-name mdjahidul-key-pair \
    --key-type rsa \
    --query "KeyMaterial" \
    --output text > mdjahidul-key-pair.pem \
    --profile temp

cat /var/log/cloud-init-output.log

aws cloudformation create-stack --stack-name jahidul-07-load-balancing-lab-7 \
                                --template-body file://lb_lab_7_1_1.yaml \
                                --profile temp

aws cloudformation update-stack --stack-name jahidul-07-load-balancing-lab-7 \
                                --template-body file://lb_lab_7_1_2.yaml \
                                --profile temp


git merge --no-commit --no-ff jahiudl/07-load-balancing