// Creating a deployment group
resource "aws_codedeploy_deployment_group" "application_deployment_group" {
  deployment_group_name  = var.env
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  app_name               = aws_codedeploy_app.app_codedeploy.name
  service_role_arn       = aws_iam_role.iam_role_for_codedeploy.arn

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
      value = var.tags["Name"]
    }
  }

  trigger_configuration {
    trigger_name       = var.name
    trigger_target_arn = aws_sns_topic.sns_for_codedeploy.arn
    trigger_events     = ["DeploymentStart", "DeploymentSuccess", "DeploymentRollback", "DeploymentFailure"]
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = var.tags
}