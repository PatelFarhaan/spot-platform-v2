// Fetching ZoneID
data "aws_route53_zone" "selected" {
  name = var.zone_name
}


#// Redirect non-naked domain to LB
#resource "aws_route53_record" "dualstack_alias" {
#  count = length(var.dns_names)
#
#  type    = "A"
#  name    = "www.${var.dns_names[count.index]["dns"]}"
#  zone_id = data.aws_route53_zone.selected.zone_id
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  alias {
#    evaluate_target_health = false
#    zone_id                = data.aws_lb.global_mcp_apps_load_balancer.zone_id
#    name                   = "dualstack.${data.aws_lb.global_mcp_apps_load_balancer.dns_name}"
#  }
#}

// Redirect non-naked domain to LB
resource "aws_route53_record" "dualstack_alias" {
  for_each = {for dns in var.dns_names : dns["name"] => dns}

  type    = "A"
  name    = "www.${each.value["dns"]}"
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


#// Redirect naked domain to www
#resource "aws_route53_record" "www_redirect_for_mcp_apps" {
#  count = length(var.dns_names)
#
#  type    = "A"
#  name    = var.dns_names[count.index]["dns"]
#  zone_id = data.aws_route53_zone.selected.zone_id
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  alias {
#    evaluate_target_health = false
#    zone_id                = data.aws_lb.global_mcp_apps_load_balancer.zone_id
#    name                   = "dualstack.${data.aws_lb.global_mcp_apps_load_balancer.dns_name}"
#  }
#}


// Redirect naked domain to www
resource "aws_route53_record" "www_redirect_for_mcp_apps" {
  for_each = {for dns in var.dns_names : dns["name"] => dns}

  type    = "A"
  name    = each.value["dns"]
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


#// Apply ACM Domain records
#resource "aws_route53_record" "acm_validation_record" {
#  count = length(flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*]))
#
#  ttl             = 60
#  allow_overwrite = true
#  zone_id         = data.aws_route53_zone.selected.zone_id
#  name            = flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*])[count.index].resource_record_name
#  type            = flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*])[count.index].resource_record_type
#  records         = [
#    flatten(aws_acm_certificate.mcp_app_certs[*].domain_validation_options[*])[count.index].resource_record_value
#  ]
#}


#resource "aws_route53_record" "acm_validation_record" {
#  for_each = {
#    for cert_name, cert in aws_acm_certificate.mcp_app_certs : cert_name => cert.domain_validation_options[*]
#  }
#
#  name    = each.value[0]["resource_record_name"]
#  type    = each.value[0]["resource_record_type"]
#  zone_id = data.aws_route53_zone.selected.zone_id
#
#  ttl             = 60
#  allow_overwrite = true
#
#  records = [
#    for rd in each.value: rd["resource_record_value"]
#  ]
#}



#resource "aws_route53_record" "acm_validation_record" {
#  for_each = {
#    for cert in aws_acm_certificate.mcp_app_certs : cert.domain_name => {
#      for validation in cert.domain_validation_options : validation.resource_record_name => {
#        name    = validation.resource_record_name
#        type    = validation.resource_record_type
#        value   = validation.resource_record_value
#        cert    = cert
#        validation = validation
#      }
#    }
#  }
#
#  ttl             = 60
#  allow_overwrite = true
#  zone_id         = data.aws_route53_zone.selected.zone_id
#
#  name            = each.value.name
#  type            = each.value["type"]
#  records         = [each.value["value"]]
#}





resource "aws_route53_record" "acm_validation_record" {
  count = length(local.acm_validation_records)

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = local.acm_validation_records[count.index]["resource_record_name"]
  type    = local.acm_validation_records[count.index]["resource_record_type"]

  ttl             = 60
  allow_overwrite = true

  records = [
    local.acm_validation_records[count.index]["resource_record_value"]
  ]
}
