// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-apps-tf-state"
    key            = "backend/terraform.tfstate"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = jsondecode(file("./../config/config.json"))
}

module "backend-us-east-1" {
  source = "../../../tf_modules/dev/web_app"

  app                               = local.config_data.app
  env                               = local.config_data.env
  tags                              = local.config_data.tags
  region                            = local.config_data.region
  ami_id                            = local.config_data.ami_id
  dns_name                          = local.config_data.dns_name
  volume_type                       = local.config_data.volume_type
  prefix_name                       = local.config_data.prefix_name
  key_name                          = local.config_data.ssh_key_name
  ebs_volume_size                   = local.config_data.ebs_volume_size
  sns_subscriptions                 = local.config_data.sns_subscriptions
  zone_name                         = local.config_data.internal_zone_name
  mcp_sg_id                         = local.config_data.internal_mcp_sg_id
  client_defined_policies           = local.config_data.client_defined_policies
  internal_s3_worker_bucket         = local.config_data.internal_s3_worker_bucket
  lb_algorithm_type                 = local.config_data.internal_lb_algorithm_type
  spot_plane_bucket                 = local.config_data.internal_spot_plane_bucket
  internal_s3_spot_plane_bucket     = local.config_data.internal_s3_spot_plane_bucket
  global_dev_apps_load_balancer_arn = local.config_data.internal_global_dev_apps_lb_arn
  name                              = "${local.config_data.internal_platform}-${local.config_data.env}-${local.config_data
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
