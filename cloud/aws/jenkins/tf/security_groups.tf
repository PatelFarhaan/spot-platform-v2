// Defining SG rules
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-mcp-dev-us-east-1"
  description = "Security Group for Jenkins"
  vpc_id      = "vpc-08da13046fc0ea8fc"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.lb_security_group.id]
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

  #  tags = var.tags
}

// create a security group for lb
resource "aws_security_group" "lb_security_group" {
  vpc_id      = "vpc-08da13046fc0ea8fc"
  name        = "jenkins-load-balancer"
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

  tags = {
    Name = "jenkins-load-balancer"
  }
}