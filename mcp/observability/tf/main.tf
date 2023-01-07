// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    key            = "mcp/terraform.tfstate"
    bucket         = "biosmesh-apps-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = yamldecode(file("./../config.yml"))
}

module "mcp_bios" {
  source = "./../mcp_module"

  app                   = local.config_data.app
  env                   = local.config_data.env
  tags                  = local.config_data.tags
  region                = local.config_data.region
  vpc_id                = local.config_data.vpc_id
  zone_id               = local.config_data.zone_id
  key_name              = local.config_data.key_name
  dns_name              = local.config_data.dns_name
  subnets               = local.config_data.subnet_ids
  instance_type         = local.config_data.instance_type
  private_key_name_path = local.config_data.private_key_name_path
  name                  = "${local.config_data.app}-${local.config_data.env}"
  regional_name         = "${local.config_data.app}-${local.config_data.env}-${local.config_data.region}"
}
