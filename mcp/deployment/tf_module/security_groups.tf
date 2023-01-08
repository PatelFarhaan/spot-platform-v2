// Defining SG rules
resource "aws_security_group" "app_sg" {
  name        = var.regional_name
  description = "Security Group for Application"
  vpc_id      = data.aws_lb.global_dev_apps_load_balancer.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = data.aws_lb.global_dev_apps_load_balancer.security_groups
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

  tags = var.tags
}
