output "region" {
  value = var.region
}

output "load_balancer" {
  value = aws_lb.load_balancer.dns_name
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
