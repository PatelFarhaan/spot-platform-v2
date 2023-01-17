// Attaching Application Certs to LB
resource "aws_lb_listener_certificate" "jenkins_certs_attachment" {
  listener_arn    = data.aws_lb_listener.global_lb_443_listener.arn
  certificate_arn = aws_acm_certificate.application_specific_certs.arn

  depends_on = [
    aws_route53_record.www_redirect,
    aws_route53_record.dualstack_alias,
    aws_acm_certificate.application_specific_certs
  ]
}
