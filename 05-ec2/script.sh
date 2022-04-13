#!/usr/bin/env bash
aws cloudformation update-stack --stack-name jahidul-05-ec2-lab \
                                --template-body file://ec2_lab_5_1_2.yaml \
                                --profile temp
aws cloudformation wait stack-update-complete \
--stack-name jahidul-05-ec2-lab \
--profile temp