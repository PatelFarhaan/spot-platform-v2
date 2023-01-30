# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import os
import sys
import shutil
from os import environ
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
        print(f"Disk details for {self.volume_id}")
        os.system("lsblk")
        os.system("df -h")
        os.system('growpart /dev/xvda 1 && resize2fs /dev/xvda1')

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
