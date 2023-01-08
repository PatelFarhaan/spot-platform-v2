// Security Group for Global LB
resource "aws_security_group" "global_dev_apps_lb_security_group" {
  vpc_id      = var.vpc_id
  name        = "${var.global_dev_apps_lb}-${var.region}-lb-sg"
  description = "Allow all inbound traffic for global dev apps load balancer"

  dynamic "ingress" {
    for_each = var.global_dev_apps_lb_ingress

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
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" : "${var.global_dev_apps_lb}-${var.region}-lb-sg"
    }
  )
}
