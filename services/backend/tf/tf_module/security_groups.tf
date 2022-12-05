// Defining SG rules
resource "aws_security_group" "app_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-app-sg"
  description = "Security Group for Application"

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
    security_groups = [var.mcp_sg_id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.mcp_sg_id]
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

  tags = var.tags
}


// create a security group for lb
resource "aws_security_group" "lb_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-lb-sg"
  description = "Allow all inbound traffic on port 80 and 443 for load balancer"

  dynamic "ingress" {
    for_each = var.alb_security_group

    content {
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      from_port   = ingress.value.from_port
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}