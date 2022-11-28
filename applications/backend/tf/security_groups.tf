// Defining SG rules
resource "aws_security_group" "app_sg" {
  vpc_id      = local.config_data.vpc_id
  description = "Security Group for Application"
  name        = "${local.config_data.app}-${local.config_data.env}-${local.config_data.region}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lb_security_group.id]
  }

  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [local.config_data.mcp_sg_id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [local.config_data.mcp_sg_id]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.config_data.tags
}

// create a security group for lb
resource "aws_security_group" "lb_security_group" {
  name        = local.config_data.name
  vpc_id      = local.config_data.vpc_id
  description = "open for all traffic on port 80, 443, 22 for load balancer"

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.config_data.tags
}