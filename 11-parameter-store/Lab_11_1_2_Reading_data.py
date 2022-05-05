import boto3
import logging
from pprint import pprint

client = boto3.client('ssm')
logging.getLogger().setLevel(logging.INFO)


def get_ssm_param():
    response = client.get_parameter(
        Name='/mdjahidul.islam.labs/stelligent-u/lab11/name',
    )
    logging.info('SSM Param name:{}'.format(response))


def get_ssm_parameters():
    response = client.get_parameters(
        Names=[
            '/mdjahidul.islam.labs/stelligent-u/lab11/name',
            '/mdjahidul.islam.labs/stelligent-u/lab11/name/team',
            '/mdjahidul.islam.labs/stelligent-u/lab11/name/timezone'
            '/mdjahidul.islam.labs/stelligent-u/lab11/name/state'
            '/mdjahidul.islam.labs/stelligent-u/lab11/name/startdate'
        ],
        WithDecryption=False
    )
    logging.info('SSM Parameters {}'.format(response))
    pprint(response)


def get_ssm_parameters_by_path(path):
    response = client.get_parameters_by_path(
        Path=path,
        MaxResults=2 # reduce the number of child node
    )
    pprint(response)


if __name__ == '__main__':
    #get_ssm_param()
    #get_ssm_parameters()
    get_ssm_parameters_by_path('/mdjahidul.islam.labs/stelligent-u/lab11/name')