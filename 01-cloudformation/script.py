import boto3
import os, sys, yaml, json
"""
1. Set Profile to temp
2. Read regions value from a YAML file
3. Executes a cf template in multiple regions

"""
#region='us-east-1'
stack_name = 'jahidul-010-cloudformation-lab'
bucket_name = 'jahidul-01-cloudformation'


def read_env():
    regions_list = []
    template_file_location = 'env.yaml'
    # read entire file as yaml
    with open(template_file_location, 'r') as content_file:
        content = yaml.load(content_file, Loader=yaml.Loader)
    regions = content.get('regions')
    for key, values in regions.items():
        regions_list.append(values)
    print(regions_list)
    return regions_list


def read_cf_template():
    # file must in the same dir as script
    template_file_location = 'Lab-1-2-1.yaml'

    # read entire file as yaml
    with open(template_file_location, 'r') as content_file:
        content = yaml.load(content_file, Loader=yaml.Loader)

    # print(type(content))
    # print(content)
    # convert yaml to json string
    content = json.dumps(content)
    return content


def get_sts_token(region):
    client = boto3.client('sts')
    mfa = sys.argv[1]
    # Get MFA value form the system
    response = client.get_session_token(
        DurationSeconds=129600,
        SerialNumber='arn:aws:iam::324320755747:mfa/mdjahidul.islam.labs',
        TokenCode= mfa
    )
    # aws_access_key_id = "aws_access_key_id = " + response.get('Credentials').get('AccessKeyId') + "\n"
    # aws_secret_access_key = "aws_secret_access_key = " + response.get('Credentials').get('SecretAccessKey') + "\n"
    # aws_session_token = "aws_session_token = " + response.get('Credentials').get('SessionToken') + "\n"
    client = boto3.client(
        'cloudformation',
        region_name=region,
        aws_access_key_id=response.get('Credentials').get('AccessKeyId'),
        aws_secret_access_key=response.get('Credentials').get('SecretAccessKey'),
        aws_session_token=response.get('Credentials').get('SessionToken')
    )
    return client


def create_stack(region):
    session = boto3.Session(profile_name='temp')
    temp_cf_client = session.client('cloudformation', region_name=region)
    response = temp_cf_client.create_stack(
        StackName=stack_name,
        TemplateBody=read_cf_template(),
        Parameters=[
            {
                'ParameterKey': 'BucketName',
                'ParameterValue': bucket_name,
                'UsePreviousValue': False
            },
        ],
        # DisableRollback=True,
        # Capabilities=[
        #     'CAPABILITY_IAM'
        #     ],
        ResourceTypes=[
            'AWS::S3::Bucket',
        ],
        OnFailure='ROLLBACK',
        EnableTerminationProtection=False
    )
    return response

#create_stack()
#read_cf_template()
#read_env()


if __name__ == '__main__':
    region_list = read_env()
    for r in region_list:
        print(r)
        response = create_stack(r)
        print("Stack Created".format(response))