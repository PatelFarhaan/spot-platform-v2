// creating a Load Balancer
resource "aws_lb" "load_balancer" {
  idle_timeout                     = 3600
  enable_cross_zone_load_balancing = true
  internal                         = false
  enable_deletion_protection       = false
  ip_address_type                  = "ipv4"
  name                             = var.name
  subnets                          = var.subnets
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb_security_group.id]

  tags = var.tags
}