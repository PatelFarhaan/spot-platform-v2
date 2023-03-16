output "region" {
  value = var.region
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.app_codedeploy.name
}

output "spot_asg_name" {
  value = aws_autoscaling_group.spot_autoscaling_group.name
}

output "od_asg_name" {
  value = aws_autoscaling_group.on_demand_autoscaling_group.name
}
