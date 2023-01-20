resource "null_resource" "push_output_to_s3" {
  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_s3_bucket.mcp_bucket,
    aws_lb.global_dev_apps_lb,
    aws_lb.global_mcp_apps_lb,
    aws_s3_bucket.worker_bucket,
    aws_s3_bucket.tfstate_bucket,
    aws_kms_key.vault_auto_unseal,
    aws_ecr_repository.apps_private_repo,
    aws_dynamodb_table.tfstate_dynamodb_table,
    aws_lb_target_group.global_mcp_apps_target_group,
    aws_security_group.global_dev_apps_lb_security_group,
    aws_security_group.global_mcp_apps_lb_security_group
  ]

  provisioner "local-exec" {
    command = <<EOF

      mcp_bucket_name=`cat ./../config.yml | yq -r .s3_buckets.mcp` &&
      terraform output -json | jq .outputs.value > /tmp/cluster_config.json &&
      aws s3 cp /tmp/cluster_config.json s3://$mcp_bucket_name
    EOF
  }
}
