#!/bin/bash
# Read region information from external file and execute below command
#regions=("us-east-1" "us-east-2" "us-west-1" "us-west-2" )
yq eval 'region' env.yaml

for region in "${regions[@]}"
do
    # aws cloudformation create-stack --stack-name jahidul-010-cloudformation-lab-$region --template-body file://Lab-1-2-1.yaml --region $region --profile temp --capabilities CAPABILITY_NAMED_IAM
    echo region
done
