#!/bin/bash

set -e -x
cd /app_path/

spot_plane_bucket="biosmesh-spot-plane"
internal_s3_worker_bucket="biosmesh-apps-config"
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
tags=$(aws ec2 describe-tags --region "$region" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')

env=$(echo $tags | jq -r '.[] | select (.Key == "Environment") | .Value')
application=$(echo $tags | jq -r '.[] | select (.Key == "Application") | .Value')
app_type=$(echo $tags | jq -r '.[] | select (.Key == "spotops.app.type") | .Value')

app_config_path="$env/$application"
aws s3 cp "s3://$internal_s3_worker_bucket/$app_config_path/" /app_path/ --recursive

AWS_ECR_ID=$(cat deployment.json | jq -r .AWS_ECR_ID)
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$AWS_ECR_ID"

echo $(cat deployment.json | jq --arg newval "$region" '. += { region: $newval }') >deployment.json
echo $(cat deployment.json | jq --arg newval "$env" '. += { ENVIRONMENT: $newval }') >deployment.json
echo $(cat deployment.json | jq --arg newval "$application" '. += { APPLICATION: $newval }') >deployment.json

if [ "$app_type" == "app" ]; then
  cp /usr/src/app/apps/* /app_path/ --recursive
fi

cd /usr/src/app/apps/sidecar &&

python3 export_env/run.py &&
mv /app_path/deployment.sh /etc/profile.d/ &&
chmod +x /etc/profile.d/deployment.sh &&
source /etc/profile.d/deployment.sh && echo "Exported ENV VARS"

python3 nginx_conf/run.py &&
python3 update_dc/run.py &&
python3 vault/run.py && echo "PATCHED DOCKER COMPOSE"


rm -rf /app_path/deployment.json &&
cd ./../
rm -rf delete sidecar folder

docker-compose -f /app_path/docker-compose.yml up -d --build --force-recreate --remove-orphans
sleep 10

set +x
