# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import requests
from boto3 import client, resource


# <==================================================================================================>
#                                             AWS SERVICES
# <==================================================================================================>
class AWS(object):
    def __init__(self):
        self.region = self.get_aws_region()
        self.instance_id = self.get_instance_id()

    def get_boto3_client(self, service_name: str) -> client:
        return client(service_name, region_name=self.region)

    def get_boto3_resource(self, service_name: str) -> resource:
        return resource(service_name, region_name=self.region)

    def get_volume_id(self):
        instance_id = self.get_instance_id()
        client = self.get_boto3_client("ec2")
        volumes = client.describe_instance_attribute(InstanceId=instance_id,
                                                         Attribute='blockDeviceMapping')

    def increase_ebs_size(self):
        client = self.get_boto3_client("ec2")
        response = client.modify_volume(VolumeId='vol-xxxxxxxx', VolumeType='io1', Iops=100)

    def get_instance_id(self):
        url = "http://169.254.169.254/latest/meta-data/instance-id"
        return requests.get(url).text

    def get_aws_region(self):
        url = "http://169.254.169.254/latest/meta-data/placement/region"
        return requests.get(url).text
