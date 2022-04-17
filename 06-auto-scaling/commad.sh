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
aws cloudformation update-stack --stack-name jahidul-06-auto-sacling-lab-lab-6-1-2 \
                                --template-body file://auto_sacling_lab_6_1_5.yaml \
                                --profile temp