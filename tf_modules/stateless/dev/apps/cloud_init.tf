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

host_dc_file=$(cat <<- EOIF
version: "3.8"

networks:
  spotops_monitoring:

x-logging: &default-logging
  driver: "json-file"
  options:
    tag: "{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}"

services:
  promtail:
    restart: always
    image: $ecr_mcp:promtail
    container_name: promtail
    volumes:
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command:
      -config.expand-env=true
      -config.file=/etc/promtail/promtail-config.yml
    environment:
      - "HOSTNAME=$hostname"
      - "ENVIRONMENT=internal"
      - "APPLICATION=deamon_sidecar"
      - "LOKI_URL=https://mcp.observability.biosapplication.com/loki/api/v1/push"
    depends_on:
      - host_sidecar
    deploy:
      resources:
        limits:
          memory: 30M
    networks:
      - spotops_monitoring

  host_sidecar:
    user: root
    privileged: true
    container_name: $hostname
    logging: *default-logging
    image: $ecr_mcp:host-sidecar
    volumes:
      - "./:/app_path/"
      - "/etc/profile.d/:/etc/profile.d/"
      - "/var/run/docker.sock:/var/run/docker.sock"
EOIF
)

echo "$host_dc_file" > ./docker-compose.host.yml

sudo -E docker-compose -f docker-compose.host.yml up --force-recreate --remove-orphans --abort-on-container-exit &&
source /etc/profile.d/deployment.sh &&

echo "Staring docker containers..."
sudo -E docker-compose -f docker-compose.yml up -d --build --force-recreate --remove-orphans
sleep 10

echo "SIDECAR SUCCESSFULLY COMPLETED!!!"
EOF
}
