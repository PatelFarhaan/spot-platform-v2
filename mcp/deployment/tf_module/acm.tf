// Jenkins Certs
resource "aws_acm_certificate" "mcp_observability_jenkins_certs" {
  validation_method = "DNS"
  domain_name       = var.dns_name_jenkins

  subject_alternative_names = [
    "www.${var.dns_name_jenkins}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}


// Vault Certs
resource "aws_acm_certificate" "mcp_observability_vault_certs" {
  validation_method = "DNS"
  domain_name       = var.dns_name_vault

  subject_alternative_names = [
    "www.${var.dns_name_vault}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
