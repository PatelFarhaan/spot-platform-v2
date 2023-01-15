// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
    key            = "mcp-deployment-stack/terraform.tfstate"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = yamldecode(file("./../config.yml"))
}


// Reading variables from cluster_config.yml file
locals {
  cluster_config = yamldecode(file("./../cluster_config.yml"))
}


// MCP Module
module "mcp_deployment_stack" {
  source = "../tf_module"

  app                          = local.config_data.app
  env                          = local.config_data.env
  tags                         = local.config_data.tags
  region                       = local.config_data.region
  key_name                     = local.config_data.key_name
  instance_type                = local.config_data.instance_type
  dns_name_vault               = local.config_data.dns_name_vault
  kms_id                       = local.cluster_config.vault_kms_id
  dns_name_jenkins             = local.config_data.dns_name_jenkins
  zone_name                    = local.cluster_config.global_zone_name_1
  private_key_name_path        = local.config_data.private_key_name_path
  global_mcp_load_balancer_arn = local.cluster_config.global_mcp_apps_lb_arn
  mcp_vault_bucket             = local.cluster_config.s3_mcp_vault_bucket_name
  mcp_spot_bucket              = local.cluster_config.s3_mcp_spot_plane_bucket_name
  name                         = "${local.config_data.app}-${local.config_data.env}"
  regional_name                = "${local.config_data.app}-${local.config_data.env}-${local.config_data.region}"
}
