# <==================================================================================================>
#                                         IMPORTS
# <==================================================================================================>
import json
import sys
from os import environ

import requests

from aws import AWS


# <==================================================================================================>
#                                     SEND NOTIFICATION IN SLACK
# <==================================================================================================>
class Notification(AWS):
    def __init__(self):
        super().__init__()

    def send_slack_notification(self):
        slack_data = {
            "username": "SpotopsBot",
            "attachments": [
                {
                    "color": "#7bf538",
                    "fields": [
                        {
                            "title": f"INCREASED EBS VOLUME",
                            "value": f"""InstanceId: {self.instance_id}\n VolumeId: {self.volume_id}\n OriginalSize: {self.original_size}Gb \n TargetSize: {self.target_size}Gb"""
                        }
                    ]
                }
            ]
        }
        self.send_request(slack_data)

    @staticmethod
    def send_request(slack_data):
        slack_webhook_url = environ["SLACK_WEBHOOK"]
        byte_length = str(sys.getsizeof(slack_data))
        headers = {'Content-Type': "application/json", 'Content-Length': byte_length}
        try:
            response = requests.post(slack_webhook_url, data=json.dumps(slack_data), headers=headers)
            if response.status_code == 200:
                print("Success!!!")
            else:
                print(f"Failed: {response.status_code}")
        except Exception as e:
            print("Failed!!!", e)
            sys.exit(1)
