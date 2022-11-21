// Creating an SNS topic for CodeDeploy notifications
resource "aws_sns_topic" "sns_for_codedeploy" {
  name = "${local.config_data.name}-${local.config_data.env}"

  tags = local.config_data.tags
}