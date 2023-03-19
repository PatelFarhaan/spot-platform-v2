// Creating Certs
resource "aws_acm_certificate" "mcp_app_certs" {
  for_each = local.unique_dns_list

  validation_method = "DNS"
  domain_name       = each.value

  subject_alternative_names = [
    "www.${each.value}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}


// Validate ACM Certs
resource "aws_acm_certificate_validation" "mcp_app_certs_validation" {
  for_each = local.unique_dns_list

  certificate_arn         = aws_acm_certificate.mcp_app_certs[each.value].arn
  validation_record_fqdns = concat(
    [
      for record in aws_route53_record.acm_validation_record_naked_domain : record.fqdn
    ],
    [
      for record in aws_route53_record.acm_validation_record_non_naked_domain : record.fqdn
    ]
  )
}
