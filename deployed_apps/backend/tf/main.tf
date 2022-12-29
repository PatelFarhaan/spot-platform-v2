// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "bios-apps-tf-state"
    key            = "backend/terraform.tfstate"
    dynamodb_table = "bios-dynamodb-tflock-state"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = jsondecode(file("./../config.json"))
}

module "backend-us-east-1" {
  source = "../../../tf_module"

  app                           = local.config_data.app
  env                           = local.config_data.env
  tags                          = local.config_data.tags
  region                        = local.config_data.region
  ami_id                        = local.config_data.ami_id
  vpc_id                        = local.config_data.vpc_id
  zone_id                       = local.config_data.zone_id
  dns_name                      = local.config_data.dns_name
  subnets                       = local.config_data.subnet_ids
  volume_type                   = local.config_data.volume_type
  prefix_name                   = local.config_data.prefix_name
  key_name                      = local.config_data.ssh_key_name
  ebs_volume_size               = local.config_data.ebs_volume_size
  sns_subscriptions             = local.config_data.sns_subscriptions
  lb_algorithm_type             = local.config_data.lb_algorithm_type
  mcp_sg_id                     = local.config_data.internal_mcp_sg_id
  client_defined_policies       = local.config_data.client_defined_policies
  internal_s3_worker_bucket     = local.config_data.internal_s3_worker_bucket
  alb_security_group            = local.config_data.security_groups.alb.ingress
  internal_s3_spot_plane_bucket = local.config_data.internal_s3_spot_plane_bucket
  name                          = "${local.config_data.internal_platform}-${local.config_data.env}-${local.config_data
  .app}"
  global_name = "${local.config_data.internal_platform}-${local.config_data.env}-${local.config_data
  .app}-${local.config_data.region}"

  od_instance_type         = local.config_data.od_config.instance_type
  od_asg_min_instances     = local.config_data.od_config.auto_scaling_group.min_instances
  od_asg_max_instances     = local.config_data.od_config.auto_scaling_group.max_instances
  od_asg_desired_instances = local.config_data.od_config.auto_scaling_group.desired_instances

  spot_instance_type         = local.config_data.spot_config.instance_type
  spot_asg_min_instances     = local.config_data.spot_config.auto_scaling_group.min_instances
  spot_asg_max_instances     = local.config_data.spot_config.auto_scaling_group.max_instances
  spot_asg_desired_instances = local.config_data.spot_config.auto_scaling_group.desired_instances
}
