// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
    key            = "mcp-observability-stack/terraform.tfstate"
  }
}


// Reading variables from config.yml file
locals {
  config_data = yamldecode(file("./../config.yml"))
}


// Reading variables from cluster_config.yml file
locals {
  cluster_config = yamldecode(file("./../cluster_config.yml"))
}


// MCP Module
module "mcp_observability_stack" {
  source = "../tf_module"

  app                          = local.config_data.app
  env                          = local.config_data.env
  tags                         = local.config_data.tags
  region                       = local.config_data.region
  key_name                     = local.config_data.key_name
  dns_name                     = local.config_data.dns_name
  instance_type                = local.config_data.instance_type
  private_key_name_path        = local.config_data.private_key_name_path
  zone_name                    = local.cluster_config.global_zone_name_1
  global_mcp_load_balancer_arn = local.cluster_config.global_mcp_apps_lb_arn
  name                         = "${local.config_data.app}-${local.config_data.env}"
  regional_name                = "${local.config_data.app}-${local.config_data.env}-${local.config_data.region}"
}
