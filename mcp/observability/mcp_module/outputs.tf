output "instance_sg" {
  value = aws_security_group.app_sg.id
}


output "aws_service_lb" {
  value = aws_lb.load_balancer.dns_name
}
