# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import sys
import json
import shutil
import subprocess
from os import environ
from pprint import pprint
from datetime import datetime
from notification import Notification


# <==================================================================================================>
#                                       DISK SPACE CHECK UTILITY
# <==================================================================================================>
class DiskSpaceChecker(Notification):
    def __init__(self):
        super().__init__()
        self.log_obj["instance_id"] = self.instance_id
        self.free_disk_threshold_in_gb = int(environ["SCALEUP_WHEN_GB_REMAINING"])
        self.log_obj["current_dt"] = datetime.now().strftime("%b %d %Y, %H:%M:%S")

    @staticmethod
    def read_json_file(file_path):
        with open(file_path) as file:
            return json.load(file)

    def make_bash_call(self, command):
        result = subprocess.run(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        if result.returncode != 0:
            print(f"The command '{command}' failed with exit code: {result.returncode}")
            print(f"Stdout of the command is: {result.stdout}")
            print(self.log_obj)
            sys.exit(1)

    def is_disk_full(self):
        total, used, free = shutil.disk_usage("/")
        _free = free // (2 ** 30)

        if _free <= self.free_disk_threshold_in_gb:
            self.log_obj["disk_full"] = True
            self.log_obj["remaining"] = f"{_free} GB"
            return True

        self.log_obj["disk_full"] = False
        self.log_obj["remaining"] = f"{_free} GB"
        print(self.log_obj)
        sys.exit(0)

    def get_volume_mount(self):
        output_file = "/tmp/lsblk.json"
        self.make_bash_call(f"lsblk --json > {output_file}")
        lsblk_data = self.read_json_file(output_file)
        pprint(lsblk_data)

        for vol in lsblk_data["blockdevices"]:
            if vol["name"].startswith("loop"):
                continue
            elif vol["name"].startswith(("nvme", "xvda")) and "children" in vol:
                if not vol["children"]:
                    print("FAILED: Children not present in Mount Path")
                    print(self.log_obj)
                    sys.exit(1)

                if "G" in vol["children"][0]["size"]:
                    return vol["name"], vol["children"][0]["name"]

    def increase_filesize(self):
        self.log_obj["increasing_filesize"] = True
        print(f"Disk details for {self.volume_id}")
        self.make_bash_call("lsblk")
        self.make_bash_call("df -hT")

        volume_mount, partition_name = self.get_volume_mount()
        print(f"Volume Mount is: {volume_mount}")
        print(f"Partition Name is: {partition_name}")
        self.log_obj["mount_point_path"] = volume_mount
        self.log_obj["partition_name"] = partition_name
        self.make_bash_call(f"growpart /dev/{volume_mount} 1 && resize2fs /dev/{partition_name}")

    def run(self):
        self.is_disk_full()
        self.increase_ebs_size()
        self.increase_filesize()
        self.send_slack_notification()
        print(self.log_obj)


# <==================================================================================================>
#                                          MAIN CALLING FUNCTION
# <==================================================================================================>
if __name__ == '__main__':
    if environ["SCALE_VOLUME"]:
        disk_utility_obj = DiskSpaceChecker()
        disk_utility_obj.run()
