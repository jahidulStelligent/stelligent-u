#!/bin/bash
# Read region information from external file and execute below command
#regions=("us-east-1" "us-east-2" "us-west-1" "us-west-2" )
#yq eval 'region' env.yaml
regionArray=()
env=("prod" "uat" "test" "dev")
for e in "${env[@]}"
do
  region=$(cat env.yaml | yq -r .regions.$e)
  regionArray+=($region)
done

for region in "${regionArray[@]}"
do
    aws cloudformation create-stack --stack-name jahidul-010-cloudformation-lab-$region --template-body file://Lab-1-2-1.yaml --region $region --profile temp --capabilities CAPABILITY_NAMED_IAM
    #echo "Regions: "$region
done
