// User data for Spot and OD
data "template_file" "spotops_user_data" {
  template = <<EOF
#!/bin/bash

set -e -x
sudo mkdir -p /var/opt/spotops/agents
cd /var/opt/spotops/agents/

hostname=`hostname`
ecr_mcp=${var.ecr_mcp}
region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "${var.ecr_mcp}"

sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

host_dc_file=$(cat <<- EOIF
version: "3.8"

x-logging:
  &default-logging
  driver: loki
  options:
    keep-file: "false"
    loki-url: https://internal.loki.biosapplication.com/loki/api/v1/push
    loki-external-labels: "instance=$hostname,application=cloud-init,environment=internal,container_name={{.Name}}"

services:
  host_sidecar:
    user: root
    privileged: true
    container_name: $hostname
    logging: *default-logging
    image: $ecr_mcp:host-sidecar
    environment:
      - "INSTANCE_HOSTNAME=$hostname"
    volumes:
      - "./:/app_path/"
      - "/etc/profile.d/:/etc/profile.d/"
      - "/var/run/docker.sock:/var/run/docker.sock"
EOIF
)

echo "$host_dc_file" > ./docker-compose.host.yml

sudo -E docker-compose -f docker-compose.host.yml up --force-recreate --remove-orphans --abort-on-container-exit &&
sudo rm -rf ./docker-compose.host.yml &&
source /etc/profile.d/deployment.sh &&

echo "Staring docker containers..."
sudo -E docker-compose -f docker-compose.yml up -d --build --force-recreate --remove-orphans
sleep 10

echo "SIDECAR SUCCESSFULLY COMPLETED!!!"
EOF
}
