// Creating Certs
resource "aws_acm_certificate" "mcp_app_certs" {
  count = length(var.dns_names)

  validation_method = "DNS"
  domain_name       = var.dns_names[count.index]["dns"]

  subject_alternative_names = [
    "www.${var.dns_names[count.index]["dns"]}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}


// Validating ACM Service
resource "aws_acm_certificate_validation" "mcp_acm_certificate_validation" {
  count = length(var.dns_names)

  certificate_arn         = aws_acm_certificate.mcp_app_certs[count.index].arn
  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation_record : record.fqdn
  ]

  depends_on = [
    aws_route53_record.acm_validation_record
  ]
}
