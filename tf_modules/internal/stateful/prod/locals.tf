// Resources that needs to be tagged
locals {
  resources = ["volume", "network-interface"]
}


// Replacing variables for IAM Policies
locals {
  _replace_spot_bucket  = replace(var.policy_list, "var.mcp_spot_bucket", var.mcp_spot_bucket)
  _replace_vault_bucket = replace(local._replace_spot_bucket, "var.mcp_vault_bucket", var.mcp_vault_bucket)
  iam_policies          = yamldecode(local._replace_vault_bucket)
}


// Filtered DNS List
locals {
  filtered_dns_list = [
    for obj in var.dns_names : obj
    if  obj["external_port"] != 80 &&
    obj["external_port"] != 443
  ]
}


// Aggregating all ACM Records Value
locals {
  acm_validation_records = flatten([for i in aws_acm_certificate.mcp_app_certs : i.domain_validation_options])
}
