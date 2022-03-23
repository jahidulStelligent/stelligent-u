import boto3
from pprint import pprint
import sys

client = boto3.client('sts')


def update_credentials():
    # Get MFA value form the system
    mfa = sys.argv[1]
    response = client.get_session_token(
        DurationSeconds=129600,
        SerialNumber='arn:aws:iam::324320755747:mfa/mdjahidul.islam.labs',
        TokenCode= mfa
    )
    aws_access_key_id = "aws_access_key_id = " + response.get('Credentials').get('AccessKeyId') + "\n"
    aws_secret_access_key = "aws_secret_access_key = " + response.get('Credentials').get('SecretAccessKey') + "\n"
    aws_session_token = "aws_session_token = " + response.get('Credentials').get('SessionToken') + "\n"
    replace_lines(10, 11, 12, aws_access_key_id, aws_secret_access_key, aws_session_token)
    pprint('Credentials Updated')


def replace_lines(l1, l2, l3, value1, value2, value3):
    with open('/Users/mdjahidul.islam/.aws/credentials', 'r', encoding='utf-8') as file:
        data = file.readlines()

    data[l1 - 1] = value1
    data[l2 - 1] = value2
    data[l3 - 1] = value3

    with open('/Users/mdjahidul.islam/.aws/credentials', 'w', encoding='utf-8') as file:
        file.writelines(data)


update_credentials()