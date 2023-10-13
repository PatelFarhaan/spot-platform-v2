// Application Cert Manager
resource "aws_acm_certificate" "application_specific_certs" {
  for_each = local.unique_dns_list

  validation_method = "DNS"
  domain_name       = each.value

  subject_alternative_names = [
    "www.${each.value}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags,
    {
      "Name" = var.name
    }
  )
}


// Validate ACM Certs
resource "aws_acm_certificate_validation" "mcp_acm_certificate_validation" {
  for_each = local.unique_dns_list

  certificate_arn         = aws_acm_certificate.application_specific_certs[each.value].arn
  validation_record_fqdns = concat(
    [
      for record in aws_route53_record.acm_validation_record_naked_domain : record.fqdn
    ],
    [
      for record in aws_route53_record.acm_validation_record_non_naked_domain : record.fqdn
    ]
  )
}


#// Attaching ACM with Global Dev Apps Load Balancer
#resource "aws_lb_listener_certificate" "additional_lb_certs" {
#  listener_arn    = data.aws_lb_listener.global_lb_443_listener.arn
#  certificate_arn = aws_acm_certificate.application_specific_certs.arn
#
#  depends_on = [
#    aws_acm_certificate.application_specific_certs,
#    aws_route53_record.acm_validation_record_naked_domain,
#    aws_route53_record.acm_validation_record_non_naked_domain
#  ]
#}
