// Fetching ZoneID
data "aws_route53_zone" "selected" {
  name = var.zone_name
}


// Redirect non-naked domain to lb
resource "aws_route53_record" "dualstack_alias" {
  type    = "A"
  name    = "www.${var.dns_name}"
  zone_id = data.aws_route53_zone.selected.zone_id

  alias {
    evaluate_target_health = false
    zone_id                = data.aws_lb.global_dev_apps_load_balancer.zone_id
    name                   = "dualstack.${data.aws_lb.global_dev_apps_load_balancer.dns_name}"
  }
}


// Redirect naked domain to www
resource "aws_route53_record" "www_redirect" {
  type    = "A"
  name    = var.dns_name
  zone_id = data.aws_route53_zone.selected.zone_id

  alias {
    evaluate_target_health = false
    zone_id                = data.aws_lb.global_dev_apps_load_balancer.zone_id
    name                   = "dualstack.${data.aws_lb.global_dev_apps_load_balancer.dns_name}"
  }
}


// Validating ACM Records
resource "aws_route53_record" "mcp_observability_acm_records" {
  for_each = {
    for dvo in aws_acm_certificate.mcp_observability_app_certs.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  ttl             = 60
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  zone_id         = data.aws_route53_zone.selected.zone_id
}
