#! /bin/bash

set -e -x

application_path="/var/opt/spotops/agents"
mkdir -p $application_path

echo "Providing ubuntu permission to agents folder"
sudo chown ubuntu:ubuntu -R ${application_path}

echo "Running apt update and upgrade"
export DEBIAN_FRONTEND=noninteractive
sudo apt update &&
sudo apt upgrade -y &&

echo "Upgrading the distro"
sudo apt -f install
sudo apt update && sudo apt dist-upgrade -y

echo "Installing AWS CLI"
sudo apt install awscli -y

echo "Installing Python3 and boto3"
sudo apt install python3-pip -y
sudo pip3 install boto3

echo "Installing Docker"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
sudo apt update &&
sudo apt install docker-ce -y &&
sudo systemctl restart docker.service &&
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose.yml &&
sudo chmod +x /usr/local/bin/docker-compose.yml &&
sudo systemctl restart docker.socket docker.service &&
sudo usermod -aG docker ${USER}
sudo su - ${USER}

echo "Installing Python Nginx Client"
sudo pip3 install python-nginx

echo "Sourcing cloud-init-script"
sudo chmod +x ./spotops_cloud_init.sh
sudo mv ./spotops_cloud_init.sh /etc/profile.d/
source /etc/profile.d/spotops_cloud_init.sh