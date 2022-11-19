// creating a Load Balancer
resource "aws_lb" "load_balancer" {
  internal                   = false
  enable_deletion_protection = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = local.config_data.name
  subnets                    = local.config_data.subnets
  security_groups            = [aws_security_group.lb_security_group.id]

  tags = local.config_data.tags
}