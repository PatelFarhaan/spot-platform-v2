// Defining SG rules
resource "aws_security_group" "app_sg" {
  name        = "${var.name}-app-sg"
  description = "Security Group for Application"
  vpc_id      = data.aws_lb.global_dev_apps_load_balancer.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = data.aws_lb.global_dev_apps_load_balancer.security_groups
  }

  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [var.mcp_sg_id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.mcp_sg_id]
  }

  ingress {
    from_port       = 9113
    to_port         = 9113
    protocol        = "tcp"
    security_groups = [var.mcp_sg_id]
  }

  ingress {
    from_port       = 9999
    to_port         = 9999
    protocol        = "tcp"
    security_groups = data.aws_lb.global_dev_apps_load_balancer.security_groups
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" : "${var.name}-app-sg"
    }
  )
}
