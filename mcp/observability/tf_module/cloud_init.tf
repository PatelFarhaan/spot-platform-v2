data "template_file" "cloud_init_script" {
  template = <<EOF
#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
export AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`

sudo apt update -y &&
sudo apt upgrade -y &&
cd /etc/apt && sudo cp trusted.gpg trusted.gpg.d

sudo apt install docker.io -y &&
sudo systemctl start docker &&
sudo systemctl enable docker &&
sudo apt install python3-pip -y &&
sudo pip3 install docker-compose

sudo apt install ec2-instance-connect -y
cd /home/ubuntu/docker_agents &&
sudo docker-compose up -d --build
sudo snap install amazon-ssm-agent --classic && sudo snap start amazon-ssm-agent

ls /usr/share/zoneinfo
echo "America/New_York" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

sleep 10

EOF
}
