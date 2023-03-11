// Attaching Grafana Certs to LB prot 443
resource "aws_lb_listener_certificate" "grafana_certs_attachment_port_443" {
  listener_arn    = data.aws_lb_listener.global_mcp_lb_443_listener.arn
  certificate_arn = aws_acm_certificate.mcp_observability_app_certs.arn

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_route53_record.mcp_observability_acm_records
  ]
}


// Attaching Grafana Certs to LB prot 9090
resource "aws_lb_listener_certificate" "grafana_certs_attachment_port_9090" {
  listener_arn    = data.aws_lb_listener.global_mcp_lb_9090_listener.arn
  certificate_arn = aws_acm_certificate.mcp_observability_app_certs.arn

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_route53_record.mcp_observability_acm_records
  ]
}


// Attaching Grafana Certs to LB prot 9093
resource "aws_lb_listener_certificate" "grafana_certs_attachment_port_9093" {
  listener_arn    = data.aws_lb_listener.global_mcp_lb_9093_listener.arn
  certificate_arn = aws_acm_certificate.mcp_observability_app_certs.arn

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_route53_record.mcp_observability_acm_records
  ]
}
