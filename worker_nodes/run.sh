#!/bin/bash

set -e -x
cd /app_path/

# Define variables
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
tags=$(aws ec2 describe-tags --region "$region" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')

# Export variables
env=$(echo $tags | jq -r '.[] | select (.Key == "Environment") | .Value')
application=$(echo $tags | jq -r '.[] | select (.Key == "Application") | .Value')
export APPLICATION=$application
export ENVIRONMENT=$env

# Copy config files from S3
app_config_path="$env/$application"
internal_s3_worker_bucket="biosmesh-apps-config"
aws s3 cp "s3://$internal_s3_worker_bucket/$app_config_path/" /app_path/ --recursive

cp /usr/src/app/apps/* /app_path/ --recursive
cd /usr/src/app/apps/sidecar &&
  python3 nginx_conf/run.py &&
  python3 update_dc/run.py &&
  python3 vault/run.py && echo "PATCHED DOCKER COMPOSE"

cd /app_path && rm -rf deployment.json

set +x
