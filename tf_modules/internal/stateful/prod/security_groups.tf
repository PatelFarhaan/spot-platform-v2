// Defining SG rules
resource "aws_security_group" "app_sg" {
  name_prefix = var.regional_name
  description = "Security Group for Application"
  vpc_id      = data.aws_lb.global_mcp_apps_load_balancer.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = data.aws_lb.global_mcp_apps_load_balancer.security_groups
  }

  dynamic "ingress" {
    for_each = var.telemetry_sg_ports

    content {
      protocol        = "tcp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [var.telemetry_sg]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
