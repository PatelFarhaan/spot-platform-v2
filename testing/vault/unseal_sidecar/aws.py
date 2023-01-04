# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import json
import requests
from os import environ
from boto3 import client, resource


# <==================================================================================================>
#                                             AWS SERVICES
# <==================================================================================================>
class AWS:
    def __init__(self):
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

    def get_vault_keys_from_s3(self):
        local_path = "/tmp/{self.s3_filename}"
        client = self.get_boto3_client("s3")
        client.download_file(self.s3_bucket,
                             self.s3_filename,
                             local_path)
        return json.load(open(local_path))

    def put_vault_keys_to_s3(self):
        open('hello.txt').write('Hello, world!')

        # Upload the file to S3
        s3_client.upload_file('hello.txt', 'MyBucket', 'hello-remote.txt')
