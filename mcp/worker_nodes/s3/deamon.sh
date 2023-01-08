#!/bin/bash

set -e -x
cd /var/opt/spotops/agents/

node_architecture=$(uname -m)
spot_plane_bucket="biosmesh-spot-plane"
internal_s3_worker_bucket="biosmesh-apps-config"
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
tags=$(aws ec2 describe-tags --region "$region" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')

env=$(echo $tags | jq -r '.[] | select ((.Key == "Environment")) | .Value')
application=$(echo $tags | jq -r '.[] | select ((.Key == "Application")) | .Value')
app_type=$(echo $tags | jq -r '.[] | select ((.Key == "spotops.app_type")) | .Value')

app_config_path="$env/$application"
aws s3 cp "s3://$internal_s3_worker_bucket/$app_config_path/" /var/opt/spotops/agents/ --recursive

if [ "$app_type" == "webapp" ]; then
  aws s3 cp "s3://$spot_plane_bucket/worker_agents/web_apps" /var/opt/spotops/agents/ --recursive
fi

export_app_replicas() {
  mv host_scripts/app_replica.sh ./
  move_file_to_profiled "app_replica.sh"
}

configure_app_volume_mounts() {
  pip3 install ruamel.yaml # TODO
  python3 host_scripts/create_volume_mounts.py
}

move_file_to_profiled() {
  sudo mv /var/opt/spotops/agents/$1 /etc/profile.d/
  sudo chown ubuntu:ubuntu /etc/profile.d/$1
  sudo chmod +x /etc/profile.d/$1
  source /etc/profile.d/$1
}

process_application_files() {
  echo $(cat deployment.json | jq --arg newval "$env" '. += { ENVIRONMENT: $newval }') >deployment.json
  echo $(cat deployment.json | jq --arg newval "$application" '. += { APPLICATION: $newval }') >deployment.json
  python3 host_scripts/create_deployment_script.py
  move_file_to_profiled "deployment.sh"
  sudo rm -rf deployment.json
}

create_app() {
  pip3 install python-nginx # TODO
  aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$AWS_ECR_ID"
  python3 host_scripts/create_nginx_conf.py
  sudo -E docker-compose up -d --build --force-recreate --remove-orphans
  sleep 10
}

export_app_replicas
configure_app_volume_mounts
process_application_files
create_app
