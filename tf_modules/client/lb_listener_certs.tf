// Attaching Certs to LB Port 443
resource "aws_lb_listener_certificate" "alb_certs_attachment_port_443" {
  for_each = {for dns in var.routing : dns["name"] => dns}

  certificate_arn = aws_acm_certificate.application_specific_certs[each.value["dnsName"]].arn
  listener_arn    = data.aws_lb_listener.global_lb_443_listener.arn

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_acm_certificate_validation.mcp_acm_certificate_validation
  ]
}


// Attaching Certs to LB Additional Ports
resource "aws_lb_listener_certificate" "alb_certs_attachment_additional_port" {
  for_each = {
    for dns in var.routing : dns["name"] => dns if dns["servicePorts"]["external"] != 80 &&
    dns["servicePorts"]["external"] != 443
  }

  listener_arn    = aws_lb_listener.global_lb_additional_listeners[each.key].arn
  certificate_arn = aws_acm_certificate.application_specific_certs[each.value["dnsName"]].arn

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_acm_certificate_validation.mcp_acm_certificate_validation
  ]
}
