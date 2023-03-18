// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
    key            = "internal-platform-observability-stack/terraform.tfstate"
  }
}


// Reading variables from config.yml file
locals {
  config_data    = yamldecode(file("./../config.yml"))
  cluster_config = yamldecode(file("./../cluster_config.yml"))
}


// MCP Module
module "mcp_observability_stack" {
  source = "../../tf_modules/internal/stateful/prod"

  kms_id                       = 0
  mcp_vault_bucket             = 0

  app                          = local.config_data.app
  env                          = local.config_data.env
  tags                         = local.config_data.tags
  region                       = local.config_data.region
  key_name                     = local.config_data.key_name
  dns_names                    = local.config_data.dns_names
  policy_list                  = local.config_data.iam_policies
  ebs_volume_size              = local.config_data.ebs_volume_size
  availability_zones           = local.config_data.availability_zones
  dc_config_bucket_name        = local.config_data.dc_config_bucket_name
  zone_name                    = local.cluster_config.global_zone_name_1
  od_instance_type             = local.config_data.od_config.instance_types
  global_mcp_load_balancer_arn = local.cluster_config.global_mcp_apps_lb_arn
  spot_instance_type           = local.config_data.spot_config.instance_types
  ebs_multi_attach_volume_size = local.config_data.ebs_multi_attach_volume_size
  mcp_spot_bucket              = local.cluster_config.s3_mcp_spot_plane_bucket_name
  name                         = "${local.config_data.app}-${local.config_data.env}"
  od_asg_min_instances         = local.config_data.od_config.auto_scaling_group.min_instances
  od_asg_max_instances         = local.config_data.od_config.auto_scaling_group.max_instances
  spot_asg_min_instances       = local.config_data.spot_config.auto_scaling_group.min_instances
  spot_asg_max_instances       = local.config_data.spot_config.auto_scaling_group.max_instances
  od_asg_desired_instances     = local.config_data.od_config.auto_scaling_group.desired_instances
  spot_asg_desired_instances   = local.config_data.spot_config.auto_scaling_group.desired_instances
  regional_name                = "${local.config_data.app}-${local.config_data.env}-${local.config_data.region}"
}
