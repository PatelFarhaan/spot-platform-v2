// Creating a deployment group
resource "aws_codedeploy_deployment_group" "example" {
  deployment_group_name  = local.config_data.env
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  service_role_arn       = aws_iam_role.iam_role_for_codedeploy.arn
  app_name               = aws_codedeploy_app.service_codedeploy_app.name

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.target_group.name
    }
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = local.config_data.tags["Name"]
    }
  }

  trigger_configuration {
    trigger_target_arn = aws_sns_topic.sns_for_codedeploy.arn
    trigger_name       = "${local.config_data.name}-${local.config_data.env}-${local.config_data.region}"
    trigger_events     = ["DeploymentStart", "DeploymentSuccess", "DeploymentRollback", "DeploymentFailure"]
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = local.config_data.tags
}