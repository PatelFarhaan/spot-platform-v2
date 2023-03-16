data "template_file" "cloud_init_script" {
  template = <<EOF
#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
export AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`

echo """
#!/bin/bash

export AWS_REGION=`curl http://169.254.169.254/latest/meta-data/placement/region`
""" > /etc/profile.d/env.sh && source /etc/profile.d/env.sh

sudo apt update -y &&
sudo apt upgrade -y &&
sudo apt install xterm -y &&

sudo apt install docker.io -y &&
sudo systemctl start docker &&
sudo systemctl enable docker &&
sudo apt install python3-pip -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
sudo chmod +x /usr/local/bin/docker-compose

sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

sudo apt install ec2-instance-connect -y
cd /home/ubuntu/docker_agents &&
sudo -E docker-compose up -d --build
sudo snap install amazon-ssm-agent --classic && sudo snap start amazon-ssm-agent

ls /usr/share/zoneinfo
echo "America/New_York" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

sleep 10

EOF
}
