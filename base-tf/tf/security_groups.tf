// Security Group for Global LB
resource "aws_security_group" "global_lb_security_group" {
  vpc_id      = local.config_data.vpc_id
  name        = "${local.config_data.global_dev_apps_lb_name}-${local.config_data.region}-lb-sg"
  description = "Allow all inbound traffic on port 80 and 443 for global load balancer"

  dynamic "ingress" {
    for_each = local.config_data.security_groups.alb.ingress

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
    local.config_data.tags,
    {
      "Name" : "${local.config_data.global_dev_apps_lb_name}-${local.config_data.region}-lb-sg"
    }
  )
}
