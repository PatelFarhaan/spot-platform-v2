// creating a Load Balancer
resource "aws_lb" "load_balancer" {
  internal                   = false
  enable_deletion_protection = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  subnets                    = local.config_data.subnets
  name                       = "${local.config_data.name}-lb"
  security_groups            = [aws_security_group.lb_security_group.id]

  tags = local.config_data.tags
}
