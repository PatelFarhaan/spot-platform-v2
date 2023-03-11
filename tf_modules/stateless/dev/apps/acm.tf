// Application Cert Manager
resource "aws_acm_certificate" "application_specific_certs" {
  validation_method = "DNS"
  domain_name       = var.dns_name

  subject_alternative_names = [
    "www.${var.dns_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}


// Attaching ACM with Global Dev Apps Load Balancer
resource "aws_lb_listener_certificate" "additional_lb_certs" {
  listener_arn    = data.aws_lb_listener.global_lb_443_listener.arn
  certificate_arn = aws_acm_certificate.application_specific_certs.arn

  depends_on = [
    aws_route53_record.application_acm_records,
    aws_acm_certificate.application_specific_certs
  ]
}


// Validating ACM Service
resource "aws_acm_certificate_validation" "mcp_acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.application_specific_certs.arn
  validation_record_fqdns = [
    for record in aws_route53_record.application_acm_records : record.fqdn
  ]

  depends_on = [
    aws_route53_record.application_acm_records
  ]
}
