// Global apps Load Balancer
resource "aws_lb" "global_apps_lb" {
  idle_timeout               = 3600
  internal                   = false
  enable_deletion_protection = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  subnets                    = local.config_data.subnet_ids
  security_groups            = [aws_security_group.global_lb_security_group.id]
  name                       = "${local.config_data.global_dev_apps_lb_name}-${local.config_data.region}"

  tags = local.config_data.tags
}


// TODO: Make sure subnets are in all AZ
