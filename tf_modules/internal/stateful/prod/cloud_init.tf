data "template_file" "cloud_init_script" {
  template = <<EOF
#! /bin/bash

cd /home/ubuntu
mkdir -p /mnt/maebs
MOUNT_POINT="/mnt/maebs"

echo "Updating System Libraries..."
sudo apt update -y &&
sudo apt upgrade -y &&

echo "Installing Additional Libraries..."
sudo apt install jq xterm docker.io python3-pip awscli ec2-instance-connect -y
sudo systemctl start docker &&
sudo systemctl enable docker &&

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
sudo chmod +x /usr/local/bin/docker-compose
sudo docker plugin install --alias loki --grant-all-permissions grafana/loki-docker-driver:latest

export DEBIAN_FRONTEND=noninteractive
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`
tags=$(aws ec2 describe-tags --region "$AWS_REGION" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')

application=$(echo $tags | jq -r '.[] | select (.Key == "Application") | .Value')
environment=$(echo $tags | jq -r '.[] | select (.Key == "Environment") | .Value')
multi_attach_vol_id=$(echo $tags | jq -r '.[] | select (.Key == "MultiAttachEbsId") | .Value')
multi_attach_vol_size=$(echo $tags | jq -r '.[] | select (.Key == "MultiAttachEbsSize") | .Value')

echo "Attaching External MultiAttach EBS Volume..."
aws ec2 attach-volume --volume-id $multi_attach_vol_id --instance-id $instance_id --region "$AWS_REGION" --device /dev/sdf

echo "Waiting for the EBS volume to be attached..."
while [ "$(aws ec2 describe-volumes --volume-ids $multi_attach_vol_id --region "$AWS_REGION" | jq -r --arg instance_id "$instance_id" '.Volumes[].Attachments[] | select ( .InstanceId == $instance_id )|.State')" != "attached" ]; do sleep 1; done
DEVICE_NAME=$(lsblk --json | jq -r --arg multi_attach_vol_size "$multi_attach_vol_size" '.blockdevices[] | select (.name | startswith("nvme") or startswith("xvda")) | select(has("children") | not) | select (.mountpoint == null and .size == $multi_attach_vol_size) | .name')

echo "\n\n\n"
_id=$(id -u)
echo "User ID: $_id"
echo "Device Name: $DEVICE_NAME"
echo "Instance ID: $instance_id"
echo "USER and GROUPS: $USER:$GROUPS"
echo "Volume ID: $multi_attach_vol_id"
echo "\n\n\n"

echo "Checking Filesystem exists on the new volume..."
if ! file -s /dev/$DEVICE_NAME | grep -q "ext4"; then
    echo "Creating new file system on /dev/$DEVICE_NAME"
    mkfs -t ext4 /dev/$DEVICE_NAME
    chown -R ubuntu:1000 $MOUNT_POINT
fi

echo "Mounting /dev/$DEVICE_NAME to $MOUNT_POINT"
mount /dev/$DEVICE_NAME $MOUNT_POINT
chown -R ubuntu:1000 $MOUNT_POINT

if ! grep -q "$MOUNT_POINT" /etc/fstab; then
    echo "/dev/$DEVICE_NAME $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
fi

echo "Downloading Container Files from S3..."
aws s3 cp "s3://biosmesh-spot-plane/${var.dc_config_bucket_name}/" ./ --recursive &&
cd /home/ubuntu/docker_agents &&

echo """
HOSTNAME=`hostname`
APPLICATION=$application
ENVIRONMENT=$environment
AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`
""" > /home/ubuntu/docker_agents/.env &&

docker-compose up -d --build
sudo snap install amazon-ssm-agent --classic && sudo snap start amazon-ssm-agent

ls /usr/share/zoneinfo
echo "America/New_York" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

sleep 10

EOF
}
