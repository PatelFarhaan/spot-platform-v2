// User data for Spot and OD
data "template_file" "spotops_user_data" {
  template = <<EOF
#!/bin/bash

set -e -x
sudo mkdir -p /var/opt/spotops/agents
cd /var/opt/spotops/agents/

region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "${var.ecr_id}"

docker run --privileged \
  -u root \
  -v ${PWD}:/app_path/ \
  -v /etc/profile.d/:/etc/profile.d/ \
  -v /var/run/docker.sock:/var/run/docker.sock \
  "${var.ecr_id}:host-sidecar" &&

echo "Staring docker containers..."
docker-compose -f docker-compose.yml up -d --build --force-recreate --remove-orphans
sleep 10

set +x
EOF
}
