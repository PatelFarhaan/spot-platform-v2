// User data for Spot and OD
data "template_file" "spotops_user_data" {
  template = <<EOF
#!/bin/bash

set -e -x
sudo mkdir -p /var/opt/spotops/agents
cd /var/opt/spotops/agents/

apps_s3_bucket_name="biosmesh-apps-config"
plane_s3_bucket_name="biosmesh-spot-plane"
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
tags=$(aws ec2 describe-tags --region "$region" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')

env=$(echo $tags | jq -r '.[] | select ((.Key == "Environment")) | .Value')
application=$(echo $tags | jq -r '.[] | select ((.Key == "Application")) | .Value')

move_file_to_profiled() {
  sudo mv /var/opt/spotops/agents/$1 /etc/profile.d/
  sudo chown ubuntu:ubuntu /etc/profile.d/$1
  sudo chmod +x /etc/profile.d/$1
  source /etc/profile.d/$1
}

process_application_files() {
  app_config_path="$env/$application"
  aws s3 cp "s3://$apps_s3_bucket_name/$app_config_path/" /var/opt/spotops/agents/ --recursive

  echo $(cat deployment.json | jq --arg newval "$env" '. += { ENVIRONMENT: $newval }') > deployment.json
  echo $(cat deployment.json | jq --arg newval "$application" '. += { APPLICATION: $newval }') > deployment.json
  python3 create_deployment_script.py
  move_file_to_profiled "deployment.sh"
  sudo rm -rf deployment.json
}

process_worker_files() {
  aws s3 cp "s3://$plane_s3_bucket_name/worker_agents/" /var/opt/spotops/agents/ --recursive
  move_file_to_profiled "spotops_cloud_init.sh"
}

create_app() {
  pip3 install python-nginx
  aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$AWS_ECR_ID"
  python3 create_nginx_conf.py
  sudo -E docker-compose up -d --build --force-recreate --remove-orphans
  sleep 10
}

process_worker_files
process_application_files
create_app

EOF
}