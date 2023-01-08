// Application Cert Manager
resource "aws_acm_certificate" "default_global_certs" {
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


// Validating ACM Records
resource "aws_route53_record" "global_acm_records" {
  for_each = {
    for dvo in aws_acm_certificate.default_global_certs.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  ttl             = 60
  allow_overwrite = true
  zone_id         = var.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
}
