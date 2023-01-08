// Global Apps Load Balancer
resource "aws_lb" "global_dev_apps_lb" {
  idle_timeout               = 3600
  internal                   = false
  enable_deletion_protection = false
  ip_address_type            = "ipv4"
  subnets                    = var.subnets
  load_balancer_type         = "application"
  name                       = "${var.global_dev_apps_lb}-${var.region}"
  security_groups            = [aws_security_group.global_dev_apps_lb_security_group.id]

  tags = var.tags
}
