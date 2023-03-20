resource "null_resource" "export_config_to_s3" {
  count = var.export_config_to_s3 ? 1:0

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_security_group.app_sg,
    aws_acm_certificate.mcp_app_certs,
    aws_route53_record.dualstack_alias,
    aws_lb_target_group.target_group_ports,
    aws_route53_record.www_redirect_for_mcp_apps,
    aws_lb_listener_certificate.alb_certs_attachment,
    aws_lb_listener.global_mcp_lb_additional_listeners,
    aws_route53_record.acm_validation_record_naked_domain,
    aws_route53_record.acm_validation_record_non_naked_domain
  ]

  provisioner "local-exec" {
    command = <<EOF
      rm -rf /tmp/spotops
      mkdir -p /tmp/spotops &&
      mcp_bucket_name=`cat ./../cluster_config.yml | yq -r .s3_mcp_spot_plane_bucket_name` &&
      aws s3 cp s3://$mcp_bucket_name/cluster_config.json /tmp/spotops/base_config.json &&
      terraform output -json | jq .outputs.value > /tmp/spotops/observability_config.json &&

      if [ ! -s /tmp/spotops/observability_config.json ]; then
        jq -s '.[0] * .[1]' /tmp/spotops/base_config.json /tmp/spotops/observability_config.json > /tmp/spotops/cluster_config.json &&
        aws s3 cp /tmp/spotops/cluster_config.json s3://$mcp_bucket_name
      else
        echo "File Content is Empty"
      fi

    EOF
  }
}
