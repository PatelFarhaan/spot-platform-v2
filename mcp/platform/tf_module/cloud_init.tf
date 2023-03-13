data "template_file" "cloud_init_script" {
  template = <<EOF
#! /bin/bash

cd /home/ubuntu
export DEBIAN_FRONTEND=noninteractive
export AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`

echo """
#!/bin/bash

export AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`
""" > /etc/profile.d/env.sh && source /etc/profile.d/env.sh

sudo apt update -y &&
sudo apt upgrade -y &&

sudo apt install jq xterm docker.io python3-pip awscli s3fs ec2-instance-connect -y
sudo systemctl start docker &&
sudo systemctl enable docker &&

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
sudo chmod +x /usr/local/bin/docker-compose

sudo docker plugin install --alias loki --grant-all-permissions grafana/loki-docker-driver:latest

echo "Attaching External MultiAttach EBS Volume..."
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
tags=$(aws ec2 describe-tags --region "$AWS_REGION" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')
multi_attach_vol_id=$(echo $tags | jq -r '.[] | select (.Key == "MultiAttachEBS") | .Value')
aws ec2 attach-volume --volume-id $multi_attach_vol_id --instance-id $instance_id --region "$AWS_REGION" --device /dev/sdf

echo "Provisioning NFS.."
mkdir -p /mnt/s3fs
instance_profile_id=$(curl http://169.254.169.254/latest/meta-data/iam/info | jq -r '.InstanceProfileId')
instance_role=$(aws iam list-instance-profiles --query "InstanceProfiles[?InstanceProfileId=='$instance_profile_id'].Roles" | jq -r '.[0][0].RoleName')
s3fs -d ${var.mcp_spot_bucket}:/nfs/${var.s3fs_name} /mnt/s3fs -o iam_role=$instance_role -o use_cache=/tmp -o allow_other,uid=1000,gid=1000,umask=022

aws s3 cp s3://biosmesh-spot-plane/deployment/ ./ --recursive &&
cd /home/ubuntu/docker_agents &&
sudo docker-compose up -d --build
sudo snap install amazon-ssm-agent --classic && sudo snap start amazon-ssm-agent

ls /usr/share/zoneinfo
echo "America/New_York" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

sleep 10

EOF
}
