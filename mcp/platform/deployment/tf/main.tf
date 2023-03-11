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
  config_data    = yamldecode(file("./../config.yml"))
  cluster_config = yamldecode(file("./../cluster_config.yml"))
}


// MCP Module
module "mcp_deployment_stack" {
  source = "../../tf_module"

  ebs_volume_size              = local.config_data.ebs_volume_size
  app                          = local.config_data.app
  env                          = local.config_data.env
  tags                         = local.config_data.tags
  region                       = local.config_data.region
  key_name                     = local.config_data.key_name
  dns_names                    = local.config_data.dns_names
  kms_id                       = local.cluster_config.vault_kms_id
  spot_instance_type           = local.config_data.spot_config.instance_type
  zone_name                    = local.cluster_config.global_zone_name_1
  private_key_name_path        = local.config_data.private_key_name_path
  global_mcp_load_balancer_arn = local.cluster_config.global_mcp_apps_lb_arn
  mcp_vault_bucket             = local.cluster_config.s3_mcp_vault_bucket_name
  mcp_spot_bucket              = local.cluster_config.s3_mcp_spot_plane_bucket_name
  spot_asg_min_instances       = local.config_data.spot_config.auto_scaling_group.min_instances
  spot_asg_max_instances       = local.config_data.spot_config.auto_scaling_group.max_instances
  name                         = "${local.config_data.app}-${local.config_data.env}"
  spot_asg_desired_instances   = local.config_data.spot_config.auto_scaling_group.desired_instances
  regional_name                = "${local.config_data.app}-${local.config_data.env}-${local.config_data.region}"
}
