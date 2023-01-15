// User data for Spot and OD
data "template_file" "spotops_user_data" {
  template = <<EOF
#!/bin/bash

set -e -x
sudo mkdir -p /var/opt/spotops/agents
cd /var/opt/spotops/agents/

aws s3 cp "s3://${var.spot_plane_bucket}/worker_agents/deamon.sh" /var/opt/spotops/agents/
sudo bash deamon.sh && echo "Executing deamon.sh..."
rm -rf deamon.sh

EOF
}
