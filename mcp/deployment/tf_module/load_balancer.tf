// creating a Load Balancer
resource "aws_lb" "load_balancer" {
  internal                   = false
  enable_deletion_protection = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  subnets                    = var.subnets
  name                       = "${var.app}-lb"
  security_groups            = [aws_security_group.lb_security_group.id]

  tags = var.tags
}
