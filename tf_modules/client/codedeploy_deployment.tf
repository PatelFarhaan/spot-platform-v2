#// Creating a deployment group for SPOT instances
#resource "aws_codedeploy_deployment_group" "spot_application_deployment_group" {
#  for_each = {for dns in var.routing : dns["name"] => dns}
#
#  deployment_group_name  = var.env
#  deployment_config_name = "CodeDeployDefault.OneAtATime"
#  app_name               = aws_codedeploy_app.app_codedeploy.name
#  service_role_arn       = aws_iam_role.iam_role_for_codedeploy.arn
#
#  deployment_style {
#    deployment_type   = "IN_PLACE"
#    deployment_option = "WITH_TRAFFIC_CONTROL"
#  }
#
#
#  # This needs to be dynamic: create a for each loop for each target group
#  load_balancer_info {
#    target_group_info {
#      name = aws_lb_target_group.target_group[var.name].name
#    }
#  }
#
#  autoscaling_groups = [
#    aws_autoscaling_group.spot_autoscaling_group.name,
#    aws_autoscaling_group.on_demand_autoscaling_group.name
#  ]
#
#  trigger_configuration {
#    trigger_name       = var.name
#    trigger_target_arn = aws_sns_topic.sns_for_codedeploy.arn
#    trigger_events     = ["DeploymentStart", "DeploymentSuccess", "DeploymentRollback", "DeploymentFailure"]
#  }
#
#  auto_rollback_configuration {
#    enabled = true
#    events  = ["DEPLOYMENT_FAILURE"]
#  }
#
#  tags = var.tags
#}