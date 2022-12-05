#output "codedeploy_app_name" {
#  value = aws_codedeploy_app.service_codedeploy_app.name
#}
#
#output "codedeploy_group_name" {
#  value = aws_codedeploy_deployment_group.application_deployment_group.app_name
#}
#
#output "region" {
#  value = var.region
#}


#output "spot_asg_name" {
#  value = aws_autoscaling_group.spot_autoscaling_group.name
#}
#
#output "od_asg_name" {
#  value = aws_autoscaling_group.on_demand_autoscaling_group.name
#}
#
#output "load_balancer" {
#  value = aws_lb.load_balancer.dns_name
#}
#
#output "ecr_repo_name" {
#  value = aws_ecr_repository.service_private_repo.repository_url
#}