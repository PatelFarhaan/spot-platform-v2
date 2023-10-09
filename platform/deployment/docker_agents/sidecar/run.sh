#!/bin/bash

aws s3 cp s3://${SPOT_BUCKET_NAME}/cluster_config.json /tmp/cluster_config.json
vaultbucket=$(cat /tmp/cluster_config.json | jq -r .s3_mcp_vault_bucket_name)
region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
vaultkms=$(cat /tmp/cluster_config.json | jq -r .vault_kms_id)

echo $(jq --arg vaultbucket "$vaultbucket" '.backend.s3.bucket = $vaultbucket' /vault/config/config.json) >/vault/config/config.json
echo $(jq --arg vaultkms "$vaultkms" '.seal.awskms.kms_key_id = $vaultkms' /vault/config/config.json) >/vault/config/config.json
echo $(jq --arg region "$region" '.seal.awskms.region = $region' /vault/config/config.json) >/vault/config/config.json
echo $(jq --arg region "$region" '.backend.s3.region = $region' /vault/config/config.json) >/vault/config/config.json

echo "COMPLETED!"
