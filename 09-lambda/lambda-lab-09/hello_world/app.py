import json
import logging
import requests
import boto3

logging.getLogger().setLevel(logging.INFO)
client = boto3.client('dynamodb')
table_name = 'JIslamLabTable'


def lambda_handler(event, context):
    logging.info(event['body'])
    name = json.loads(event['body'])['Name']
    dynamodb_putitem(event=event)
    return {
        "statusCode": 200,
        "body": json.dumps({
            "name": name,
        }),
    }


def dynamodb_putitem(event):
    body = json.loads(event["body"])
    name = body['Name']
    id = body['ID']
    response = client.put_item(
        TableName=table_name,
        Item={
            "Name": {
                "S": name
            },
            "ID": {
                "S": id
            }
        }
    )
    logging.info('Put Item Response {}'.format(response))
    return response