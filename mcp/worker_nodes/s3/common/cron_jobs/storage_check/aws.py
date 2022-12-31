# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import time
import requests
from os import environ
from boto3 import client, resource


# <==================================================================================================>
#                                             AWS SERVICES
# <==================================================================================================>
class AWS:
    def __init__(self):
        self.log_obj = dict()
        self.region = self.get_aws_region()
        self.instance_id = self.get_instance_id()
        self.scale_up_gb = int(environ["SCALE_UP_GB"])
        self.block_device_mapping_name = environ["BLOCK_DEVICE_MAPPING_NAME"]

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

    def get_volume_id(self, _client):
        instance_id = self.get_instance_id()
        volumes = _client.describe_instance_attribute(InstanceId=instance_id,
                                                      Attribute='blockDeviceMapping')
        for volume in volumes["BlockDeviceMappings"]:
            if volume["DeviceName"] == self.block_device_mapping_name:
                vol_id = volume["Ebs"]["VolumeId"]
                self.log_obj["volume_id"] = vol_id
                return vol_id

    def get_current_volume_size(self, _client, volume_id):
        response = _client.describe_volumes(VolumeIds=[volume_id])
        volume_size = response["Volumes"][0]["Size"]
        self.log_obj["current_volume_size"] = volume_size
        return volume_size

    def check_volume_modification_status(self, _client, volume_id):
        response = _client.describe_volumes_modifications(VolumeId=volume_id)
        progress = response["VolumesModifications"][0]["Progress"]
        if progress != 100:
            time.sleep(200)
            self.check_volume_modification_status(_client, volume_id)

    def increase_ebs_size(self):
        _client = self.get_boto3_client("ec2")
        volume_id = self.get_volume_id(_client)
        original_size = self.get_current_volume_size(_client, volume_id)

        target_size = original_size + self.scale_up_gb
        response = _client.modify_volume(VolumeId=volume_id,
                                         Size=target_size)
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200
        self.log_obj["modified_volume_response"] = 200
        self.check_volume_modification_status(_client, volume_id)
