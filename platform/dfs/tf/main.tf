// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
    key            = "internal-platform-deployment-stack/terraform.tfstate"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data    = yamldecode(file("./../config.yml"))
  cluster_config = yamldecode(file("./../cluster_config.yml"))
}


// MCP Module
module "mcp_deployment_stack" {
  source = "../../../tf_modules/internal/stateful/prod"

  app                          = local.config_data.app
  env                          = local.config_data.env
  tags                         = local.config_data.tags
  ami_id                       = local.config_data.ami_id
  region                       = local.config_data.region
  routing                      = local.config_data.routing
  key_name                     = local.config_data.key_name
  policy_list                  = local.config_data.iam_policies
  kms_id                       = local.cluster_config.vault_kms_id
  ebs_volume_size              = local.config_data.ebs_volume_size
  telemetry_sg_ports           = local.config_data.telemetry_sg_ports
  availability_zones           = local.config_data.availability_zones
  export_config_to_s3          = local.config_data.export_config_to_s3
  dc_config_bucket_name        = local.config_data.dc_config_bucket_name
  zone_name                    = local.cluster_config.global_zone_name_1
  od_instance_type             = local.config_data.od_config.instance_types
  global_mcp_load_balancer_arn = local.cluster_config.global_mcp_apps_lb_arn
  spot_instance_type           = local.config_data.spot_config.instance_types
  mcp_vault_bucket             = local.cluster_config.s3_mcp_vault_bucket_name
  ebs_multi_attach_volume_size = local.config_data.ebs_multi_attach_volume_size
  telemetry_sg                 = local.cluster_config.mcp_deployment_instance_sg
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
