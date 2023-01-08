// Application Cert Manager
resource "aws_acm_certificate" "mcp_observability_app_certs" {
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
