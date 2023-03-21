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


// Filtered DNS List (non 80 and 443 records)
locals {
  filtered_dns_list = [
    for obj in var.routing : obj
    if  obj["external_port"] != 80 &&
    obj["external_port"] != 443
  ]
}


// Unique DNS List
locals {
  unique_dns_list = toset(flatten([for dns in var.routing : dns["dns"]]))
}
