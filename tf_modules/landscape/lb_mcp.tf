// Global MCP Load Balancer
resource "aws_lb" "global_mcp_apps_lb" {
  enable_cross_zone_load_balancing = true
  internal                         = false
  enable_deletion_protection       = false
  ip_address_type                  = "ipv4"
  subnets                          = var.subnets
  load_balancer_type               = "application"
  name                             = "${var.global_mcp_apps_lb}-${var.region}"
  security_groups                  = [aws_security_group.global_mcp_apps_lb_security_group.id]

  tags = var.tags
}
