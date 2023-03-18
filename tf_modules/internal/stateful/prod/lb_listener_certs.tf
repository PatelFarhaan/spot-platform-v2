#// Attaching Certs to LB
#resource "aws_lb_listener_certificate" "alb_certs_attachment" {
#  count           = length(var.dns_names)
#  certificate_arn = aws_acm_certificate.mcp_app_certs[count.index].arn
#  listener_arn    = data.aws_lb_listener.global_mcp_lb_443_listener.arn
#
#  depends_on = [
#    aws_route53_record.dualstack_alias,
#    aws_route53_record.www_redirect_for_mcp_apps,
##    aws_acm_certificate_validation.mcp_acm_certificate_validation
#  ]
#}

// Attaching Certs to LB
resource "aws_lb_listener_certificate" "alb_certs_attachment" {
  for_each = { for dns in var.dns_names : dns["name"] => dns }

  certificate_arn = aws_acm_certificate.mcp_app_certs[each.key].arn
  listener_arn    = data.aws_lb_listener.global_mcp_lb_443_listener.arn

  depends_on = [
    aws_route53_record.dualstack_alias,
    aws_route53_record.www_redirect_for_mcp_apps,
#    aws_acm_certificate_validation.mcp_app_certs_validation[aws_acm_certificate.mcp_app_certs[each.key]]
  ]
}
