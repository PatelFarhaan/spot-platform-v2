output "mcp_deployment_instance_sg" {
  value = aws_security_group.app_sg.id
}
