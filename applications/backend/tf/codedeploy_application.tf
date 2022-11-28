// Defininf application for CodeDeploy
resource "aws_codedeploy_app" "service_codedeploy_app" {
  name = "${local.config_data.name}-${local.config_data.region}"

  tags = local.config_data.tags
}
