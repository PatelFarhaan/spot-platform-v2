# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import os
import json
import requests
from os import environ
from boto3 import client, resource


# <==================================================================================================>
#                                             AWS SERVICES
# <==================================================================================================>
class AWS:
    def __init__(self):
        self.region = "us-east-1"
        self.region = self.get_aws_region()
        self.s3_bucket = environ["S3_VAULT_BUCKET"]
        self.s3_filename = environ["S3_VAULT_FILENAME"]

    def get_boto3_client(self, service_name: str) -> client:
        return client(service_name, region_name=self.region)

    def get_boto3_resource(self, service_name: str) -> resource:
        return resource(service_name, region_name=self.region)

    @staticmethod
    def get_instance_id():
        url = "http://169.254.169.254/latest/meta-data/instance-id"
        return requests.get(url).text

    @staticmethod
    def get_aws_region():
        url = "http://169.254.169.254/latest/meta-data/placement/region"
        return requests.get(url).text

    def put_vault_keys_to_s3(self, data):
        print("PUSHING SECRETS TO S3...")
        _fp = f"/tmp/{self.s3_filename}"

        _directory = "/".join(_fp.split("/")[:-1])
        if not os.path.exists(_directory):
            os.makedirs(_directory)

        with open(_fp, "w") as file:
            json.dump(data, file, indent=2)

        _client = self.get_boto3_client("s3")
        _client.upload_file(_fp,
                            self.s3_bucket,
                            self.s3_filename)
