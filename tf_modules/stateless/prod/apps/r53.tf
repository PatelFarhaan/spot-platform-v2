// Redirect non-naked domain to Load Balancer
resource "aws_route53_record" "dualstack_alias" {
  type    = "A"
  zone_id = var.zone_id
  name    = "www.${var.dns_name}"

  alias {
    evaluate_target_health = false
    zone_id                = aws_lb.load_balancer.zone_id
    name                   = "dualstack.${aws_lb.load_balancer.dns_name}."
  }
}


// Redirect naked domain to www
resource "aws_route53_record" "www_redirect" {
  type    = "A"
  zone_id = var.zone_id
  name    = var.dns_name

  alias {
    evaluate_target_health = false
    zone_id                = aws_lb.load_balancer.zone_id
    name                   = "dualstack.${aws_lb.load_balancer.dns_name}."
  }
}


// Validating ACM Records
resource "aws_route53_record" "application_acm_records" {
  for_each = {
    for dvo in aws_acm_certificate.application_specific_certs.domain_validation_options : dvo.domain_name => {
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