#// Creating Certs
#resource "aws_acm_certificate" "mcp_app_certs" {
#  count = length(var.dns_names)
#
#  validation_method = "DNS"
#  domain_name       = var.dns_names[count.index]["dns"]
#
#  subject_alternative_names = [
#    "www.${var.dns_names[count.index]["dns"]}"
#  ]
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  tags = var.tags
#}

// Creating Certs
resource "aws_acm_certificate" "mcp_app_certs" {
  for_each = { for dns in var.dns_names: dns["name"] => dns }

  validation_method = "DNS"
  domain_name       = each.value["dns"]

  subject_alternative_names = [
    "www.${each.value["dns"]}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}


#// Validating ACM Service
#resource "aws_acm_certificate_validation" "mcp_acm_certificate_validation" {
#  count = length(var.dns_names)
#
#  certificate_arn         = aws_acm_certificate.mcp_app_certs[count.index].arn
#  validation_record_fqdns = [
#    for record in aws_route53_record.acm_validation_record : record.fqdn
#  ]
#
#  depends_on = [
#    aws_route53_record.acm_validation_record
#  ]
#}

// Validate ACM certificates
resource "aws_acm_certificate_validation" "mcp_app_certs_validation" {
  for_each = { for dns in var.dns_names: dns["name"] => dns }

  certificate_arn         = aws_acm_certificate.mcp_app_certs[each.value["name"]].arn
  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation_record : record.fqdn
  ]
}


#// Validate ACM certificates
#resource "aws_acm_certificate_validation" "mcp_app_certs_validation" {
#  for_each = aws_acm_certificate.mcp_app_certs
#
#  certificate_arn         = each.value.arn
#  validation_record_fqdns = [for opt in each.value.domain_validation_options : opt.resource_record_name]
#}
