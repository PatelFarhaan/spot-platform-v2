# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import os
import sys
import shutil
from aws import AWS
from os import environ
from datetime import datetime


# <==================================================================================================>
#                                       DISK SPACE CHECK UTILITY
# <==================================================================================================>
class DiskSpaceChecker(AWS):
    def __init__(self):
        super().__init__()
        self.log_obj["instance_id"] = self.instance_id
        self.free_disk_threshold_in_gb = int(environ["SCALEUP_WHEN_IN_GB"])
        self.max_disk_size_in_gb = int(environ["DONT_SCALE_WHEN_REACHED_IN_GB"])
        self.log_obj["current_dt"] = datetime.now().strftime("%b %d %Y, %H:%M:%S")

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

    def increase_filesize(self):
        self.log_obj["increasing_filesize"] = True
        os.system("lsblk")
        stream = os.popen('sudo growpart /dev/xvda 1 && sudo resize2fs /dev/xvda1')
        print(stream.read())

    def run(self):
        self.is_disk_full()
        self.increase_ebs_size()
        self.increase_filesize()
        print(self.log_obj)


# <==================================================================================================>
#                                          MAIN CALLING FUNCTION
# <==================================================================================================>
if __name__ == '__main__':
    disk_utility_obj = DiskSpaceChecker()
    disk_utility_obj.run()
