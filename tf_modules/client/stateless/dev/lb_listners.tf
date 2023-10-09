// Fetching details of Global Load Balancer Listener for port 80
data "aws_lb_listener" "global_lb_80_listener" {
  port              = 80
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}


// Fetching details of Global Load Balancer Listener for port 443
data "aws_lb_listener" "global_lb_443_listener" {
  port              = 443
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}


// Creating Additional Dynamic Ports
resource "aws_lb_listener" "global_lb_additional_listeners" {
  for_each = {for dns in local.filtered_dns_list : dns["name"] => dns}

  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = each.value["external_port"]
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
  certificate_arn   = aws_acm_certificate.application_specific_certs[each.value["dns"]].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
  }

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_acm_certificate_validation.mcp_acm_certificate_validation
  ]

  tags = merge(var.tags,
    {
      "Name" = "${var.name}-listener-${each.value["external_port"]}"
    }
  )
}
