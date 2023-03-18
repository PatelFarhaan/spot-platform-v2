// Fetching details of Global Load Balancer Listener for port 80
data "aws_lb_listener" "global_mcp_lb_80_listener" {
  port              = 80
  load_balancer_arn = data.aws_lb.global_mcp_apps_load_balancer.arn
}


// Fetching details of Global Load Balancer Listener for port 443
data "aws_lb_listener" "global_mcp_lb_443_listener" {
  port              = 443
  load_balancer_arn = data.aws_lb.global_mcp_apps_load_balancer.arn
}


#// Creating Additional Dynamic Ports
#resource "aws_lb_listener" "global_mcp_lb_additional_listeners" {
#  count = local.filtered_dns_list
#
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = aws_acm_certificate.mcp_app_certs.arn
#  load_balancer_arn = data.aws_lb.global_mcp_apps_load_balancer.arn
#  port              = local.filtered_dns_list[count.index]["external_port"]
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.target_group_ports[count.index].arn
#  }
#
#  tags = var.tags
#}
