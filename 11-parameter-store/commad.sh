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

aws logs create-log-group --log-group-name jahidul.islam.c9logs --profile temp
aws logs create-log-stream --log-group-name jahidul.islam.c9logs --log-stream-name c9.training --profile temp
aws logs describe-log-groups --log-group-name-prefix jahidul.islam.c9logs --profile temp
aws logs describe-log-streams --log-group-name jahidul.islam.c9logs --log-stream-name-prefix c9.training --profile temp

aws cloudformation update-stack --stack-name jahidul-08-cloudwatch-logs-8 \
                                --template-body file://cw_logs_lab_8_1_2.yml \
                                --profile temp \
                                --capabilities CAPABILITY_IAM
/home/ubuntu/.local/bin

	amazon-cloudwatch-agent.log

aws cloudformation create-stack --stack-name jahidul-08-cloudwatch-logs-8 \
                                --template-body file://cw_logs_lab_8_2_1.yml \
                                --profile temp
aws cloudformation update-stack --stack-name jahidul-08-cloudwatch-logs-8 \
                                --template-body file://cw_logs_lab_8_2_1.yml \
                                --profile temp \
                                --capabilities CAPABILITY_IAM

aws apigateway test-invoke-method \
    --rest-api-id 0wkp5rmyd9 \
    --resource-id p0kaiz \
    --http-method GET \
    --path-with-query-string '/hello'

aws apigateway test-invoke-method \
    --rest-api-id 4p56wf1xl4 \
    --resource-id 1t07mg \
    --http-method POST \
    --path-with-query-string '/hello' \
    --body file://body.json

#----------------- AWS KMS ---------------------------#

aws cloudformation create-stack --stack-name jahidul-kms-lab-10 \
                                --template-body file://kms-lab-10.1.1.yaml \
                                --profile temp

aws cloudformation update-stack --stack-name jahidul-kms-lab-10 \
                                --template-body file://kms-lab-10.1.2.yaml \
                                --profile temp
# Encrypt
aws kms encrypt \
    --key-id alias/jislam-kms-alias \
    --plaintext fileb://data.txt \
    --output text \
    --query CiphertextBlob \
    --profile temp | base64 \
    --decode > encrypted_data

# Decrypt
aws kms decrypt \
    --key-id alias/jislam-kms-alias \
    --ciphertext-blob fileb://encrypted_data \
    --output text \
    --query Plaintext \
    --profile temp | base64 \
    --decode > decrypted_data.txt

# 11-parameter-store

# /mdjahidul.islam.labs/stelligent-u/lab11/

aws cloudformation create-stack --stack-name jahidul-parameter-store-lab-11 \
                                --template-body file://parameter-store-lab-11.1.1.yaml \
                                --parameters file://parameters.json

aws cloudformation update-stack --stack-name jahidul-parameter-store-lab-11 \
                                --template-body file://parameter-store-lab-11.1.1.yaml \
                                --parameters file://parameters.json

aws cloudformation create-stack --stack-name jahidul-parameter-store-lab-11-1-3 \
                                --template-body file://lb_lab_11_1_3.yaml
aws cloudformation update-stack --stack-name jahidul-parameter-store-lab-11-1-3 \
                                --template-body file://lb_lab_11_1_4.yaml

aws ec2 create-key-pair \
    --key-name mdjahidul-key-pair \
    --key-type rsa \
    --query "KeyMaterial" \
    --output text > mdjahidul-key-pair.pem

aws ssm put-parameter \
    --name "/mdjahidul.islam.labs/stelligent-u/lab11/name/middle-name" \
    --value "Islam" \
    --type "SecureString"