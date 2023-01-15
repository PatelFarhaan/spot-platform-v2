// Attaching Jenkins Certs to LB
resource "aws_lb_listener_certificate" "jenkins_certs_attachment" {
  listener_arn    = data.aws_lb_listener.global_mcp_lb_443_listener.arn
  certificate_arn = aws_acm_certificate.mcp_observability_jenkins_certs.arn

  depends_on = [
    aws_route53_record.www_redirect_for_jenkins,
    aws_route53_record.dualstack_alias_for_jenkins,
    aws_acm_certificate.mcp_observability_jenkins_certs,
    aws_route53_record.mcp_observability_acm_records_for_jenkins
  ]
}


// Attaching Vault Certs to LB
resource "aws_lb_listener_certificate" "vault_certs_attachment" {
  listener_arn    = data.aws_lb_listener.global_mcp_lb_443_listener.arn
  certificate_arn = aws_acm_certificate.mcp_observability_vault_certs.arn

  depends_on = [
    aws_route53_record.www_redirect_for_vault,
    aws_route53_record.dualstack_alias_for_vault,
    aws_acm_certificate.mcp_observability_vault_certs,
    aws_route53_record.mcp_observability_acm_records_for_vault
  ]
}
