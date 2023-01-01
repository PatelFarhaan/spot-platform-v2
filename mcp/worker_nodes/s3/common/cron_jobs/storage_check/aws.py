# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import sys
import math
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
        self.volume_id = None
        self.target_size = None
        self.original_size = None
        self.region = self.get_aws_region()
        self.instance_id = self.get_instance_id()
        self.scale_up_percentage = int(environ["SCALE_UP_PERCENTAGE"])
        self.max_disk_size_in_gb = int(environ["STOP_SCALE_WHEN_GB_REACHED"])
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

    def process_target_size(self):
        if self.original_size == self.max_disk_size_in_gb:
            print(f"{self.volume_id} REACHED ITS MAX DEFINED VOLUME LIMIT!!!")
            print(self.log_obj)
            sys.exit(1)

        scale_up_gb = self.original_size * (self.scale_up_percentage / 100)
        upper_bound = math.ceil(scale_up_gb)
        self.target_size = self.original_size + upper_bound

        if self.target_size >= self.max_disk_size_in_gb:
            self.target_size = self.max_disk_size_in_gb

        self.log_obj["target_volume_size"] = self.target_size
        print(f"Increasing volume size from {self.original_size} to {self.target_size}")

    def get_volume_id(self, _client):
        volumes = _client.describe_instance_attribute(InstanceId=self.instance_id,
                                                      Attribute='blockDeviceMapping')
        for volume in volumes["BlockDeviceMappings"]:
            if volume["DeviceName"] == self.block_device_mapping_name:
                vol_id = volume["Ebs"]["VolumeId"]
                self.log_obj["volume_id"] = vol_id
                return vol_id

    def get_current_volume_size(self, _client):
        response = _client.describe_volumes(VolumeIds=[self.volume_id])
        volume_size = response["Volumes"][0]["Size"]
        self.log_obj["original_volume_size"] = volume_size
        return volume_size

    def check_volume_modification_status(self, _client):
        response = _client.describe_volumes_modifications(VolumeIds=[self.volume_id])
        progress = response["VolumesModifications"][0]["Progress"]
        print(f"{self.volume_id} progress: {progress}%")
        if progress != 100:
            time.sleep(200)
            self.check_volume_modification_status(_client)

    def increase_ebs_size(self):
        _client = self.get_boto3_client("ec2")
        self.volume_id = self.get_volume_id(_client)
        self.original_size = self.get_current_volume_size(_client)
        self.process_target_size()

        response = _client.modify_volume(VolumeId=self.volume_id,
                                         Size=self.target_size)
        print(response)
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200
        self.log_obj["modified_volume_response"] = 200
        self.check_volume_modification_status(_client)
