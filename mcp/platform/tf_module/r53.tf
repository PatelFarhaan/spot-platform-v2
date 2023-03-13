// Fetching ZoneID
data "aws_route53_zone" "selected" {
  name = var.zone_name
}


// Redirect non-naked domain to LB
resource "aws_route53_record" "dualstack_alias" {
  count = length(var.dns_names)

  type    = "A"
  name    = "www.${var.dns_names[count.index]["dns"]}"
  zone_id = data.aws_route53_zone.selected.zone_id

  lifecycle {
    create_before_destroy = true
  }

  alias {
    evaluate_target_health = false
    zone_id                = data.aws_lb.global_mcp_apps_load_balancer.zone_id
    name                   = "dualstack.${data.aws_lb.global_mcp_apps_load_balancer.dns_name}"
  }
}


// Redirect naked domain to www
resource "aws_route53_record" "www_redirect_for_mcp_apps" {
  count = length(var.dns_names)

  type    = "A"
  name    = var.dns_names[count.index]["dns"]
  zone_id = data.aws_route53_zone.selected.zone_id

  lifecycle {
    create_before_destroy = true
  }

  alias {
    evaluate_target_health = false
    zone_id                = data.aws_lb.global_mcp_apps_load_balancer.zone_id
    name                   = "dualstack.${data.aws_lb.global_mcp_apps_load_balancer.dns_name}"
  }
}


// Apply ACM Domain records
resource "aws_route53_record" "acm_validation_record" {
  count = length(flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*]))

  ttl             = 60
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.selected.zone_id
  name            = flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*])[count.index].resource_record_name
  type            = flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*])[count.index].resource_record_type
  records         = [
    flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*])[count.index].resource_record_value
  ]
}
