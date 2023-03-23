// Attaching Certs to LB Port 443
resource "aws_lb_listener_certificate" "alb_certs_attachment_port_443" {
  for_each = {for dns in var.routing : dns["name"] => dns}

  certificate_arn = aws_acm_certificate.mcp_app_certs[each.value["dns"]].arn
  listener_arn    = data.aws_lb_listener.global_mcp_lb_443_listener.arn

  depends_on = [
    aws_route53_record.dualstack_alias,
    aws_route53_record.www_redirect_for_mcp_apps,
    aws_acm_certificate_validation.mcp_app_certs_validation
  ]
}


// Attaching Certs to LB Additional Ports
resource "aws_lb_listener_certificate" "alb_certs_attachment_additional_port" {
  for_each = {
    for dns in var.routing : dns["name"] => dns if dns["external_port"] != 80 &&
    dns["external_port"] != 443
  }

  certificate_arn = aws_acm_certificate.mcp_app_certs[each.value["dns"]].arn
  listener_arn    = aws_lb_listener.global_mcp_lb_additional_listeners[each.key].arn

  depends_on = [
    aws_route53_record.dualstack_alias,
    aws_route53_record.www_redirect_for_mcp_apps,
    aws_acm_certificate_validation.mcp_app_certs_validation
  ]
}
