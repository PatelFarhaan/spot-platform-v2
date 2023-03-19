// Fetching ZoneID
data "aws_route53_zone" "selected" {
  name = var.zone_name
}


// Redirect non-naked domain to LB
resource "aws_route53_record" "dualstack_alias" {
  for_each = local.unique_dns_list

  type    = "A"
  name    = "www.${each.value}"
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
  for_each = local.unique_dns_list

  type    = "A"
  name    = each.value
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


// Apply ACM Domain Records for Naked Domain
resource "aws_route53_record" "acm_validation_record_naked_domain" {
  for_each = {
    for cert in aws_acm_certificate.mcp_app_certs : cert.domain_name => {
      for dvo in cert.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        type   = dvo.resource_record_type
        record = dvo.resource_record_value
      }
    }
  }

  ttl             = 60
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.selected.zone_id

  name    = each.value[each.key]["name"]
  type    = each.value[each.key]["type"]
  records = [each.value[each.key]["record"]]
}


// Apply ACM Domain Records for Non-Naked Domain
resource "aws_route53_record" "acm_validation_record_non_naked_domain" {
  for_each = {
    for cert in aws_acm_certificate.mcp_app_certs : cert.domain_name => {
      for dvo in cert.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        type   = dvo.resource_record_type
        record = dvo.resource_record_value
      }
    }
  }

  ttl             = 60
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.selected.zone_id

  name    = each.value["www.${each.key}"]["name"]
  type    = each.value["www.${each.key}"]["type"]
  records = [each.value["www.${each.key}"]["record"]]
}
