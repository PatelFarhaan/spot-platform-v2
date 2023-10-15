// Defining the provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


// Reading variables from config.yml file
locals {
  config_data = yamldecode(file("./../config.yml"))
}


// Base TF Module
module "base_tf_module" {
  source = "../../../tf_modules/landscape"

  tags                       = local.config_data.tags
  region                     = local.config_data.region
  vpc_id                     = local.config_data.vpc_id
  ecr_mcp                    = local.config_data.ecr.mcp
  zone_id                    = local.config_data.zone_id
  dns_name                   = local.config_data.dns_name
  ecr_apps                   = local.config_data.ecr.apps
  kms_name                   = local.config_data.kms_name
  subnets                    = local.config_data.subnet_ids
  dynamodb_name              = local.config_data.dynamodb_name
  mcp_bucket                 = local.config_data.s3_buckets.mcp
  vault_bucket               = local.config_data.s3_buckets.vault
  tfstate_bucket             = local.config_data.s3_buckets.tfstate
  client_apps_bucket         = local.config_data.s3_buckets.client_apps
  static_hosting_bucket      = local.config_data.s3_buckets.static_hosting
  global_mcp_apps_lb         = local.config_data.load_balancers.global_mcp_apps
  global_dev_apps_lb         = local.config_data.load_balancers.global_dev_apps
  global_dev_apps_lb_ingress = local.config_data.security_groups.global_dev_apps.alb.ingress
  global_mcp_apps_lb_ingress = local.config_data.security_groups.global_mcp_apps.alb.ingress
}
