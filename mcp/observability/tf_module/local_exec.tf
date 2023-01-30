resource "null_resource" "push_output_to_s3" {
  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_security_group.app_sg,
    aws_instance.ec2_instance,
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_lb_target_group.target_group_port_80,
    aws_lb_target_group.target_group_port_9090,
    aws_lb_target_group.target_group_port_9093,
    aws_acm_certificate.mcp_observability_app_certs,
    aws_route53_record.mcp_observability_acm_records,
    aws_lb_listener_certificate.grafana_certs_attachment_port_443,
    aws_lb_listener_certificate.grafana_certs_attachment_port_9090,
    aws_lb_listener_certificate.grafana_certs_attachment_port_9093
  ]

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p /tmp/spotops &&
      mcp_bucket_name=`cat ./../config.yml | yq -r .s3_buckets.mcp` &&
      aws s3 cp s3://$mcp_bucket_name/cluster_config.json /tmp/spotops/base_config.json &&
      terraform output -json | jq .outputs.value > /tmp/spotops/observability_config.json &&
      jq -s '.[0] * .[1]' /tmp/spotops/base_config.json /tmp/spotops/observability_config.json > /tmp/spotops/cluster_config.json &&
      aws s3 cp /tmp/spotops/cluster_config.json s3://$mcp_bucket_name
    EOF
  }
}
