// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
    key            = "development/devops/terraform.tfstate"
  }
}


// Reading data variables from app_config.json file
locals {
  app_data = jsondecode(file("./../config/app_config.json"))
  #  internal_data = jsondecode(file("./../config/internal_config.json"))
}


module "development-devops-us-east-1" {
  source = "../../../tf_modules/stateless/dev/apps"

  app                               = local.app_data.app
  env                               = local.app_data.env
  tags                              = local.app_data.tags
  region                            = local.app_data.region
  ami_id                            = local.app_data.ami_id
  dns_name                          = local.app_data.dns_name
  volume_type                       = local.app_data.volume_type
  prefix_name                       = local.app_data.prefix_name
  key_name                          = local.app_data.ssh_key_name
  ebs_volume_size                   = local.app_data.ebs_volume_size
  ecr_mcp                           = local.app_data.internal_ecr_mcp
  sns_subscriptions                 = local.app_data.sns_subscriptions
  zone_name                         = local.app_data.internal_zone_name
  mcp_sg_id                         = local.app_data.internal_mcp_sg_id
  client_defined_policies           = local.app_data.client_defined_policies
  internal_s3_worker_bucket         = local.app_data.internal_s3_worker_bucket
  lb_algorithm_type                 = local.app_data.internal_lb_algorithm_type
  spot_plane_bucket                 = local.app_data.internal_spot_plane_bucket
  internal_s3_spot_plane_bucket     = local.app_data.internal_s3_spot_plane_bucket
  global_dev_apps_load_balancer_arn = local.app_data.internal_global_dev_apps_lb_arn
  name                              = "${local.app_data.internal_platform}-${local.app_data.env}-${local.app_data.app}"
  global_name                       = "${local.app_data.internal_platform}-${local.app_data.env}-${local.app_data.app}-${local.app_data.region}"

  od_instance_type         = local.app_data.od_config.instance_type
  od_asg_min_instances     = local.app_data.od_config.auto_scaling_group.min_instances
  od_asg_max_instances     = local.app_data.od_config.auto_scaling_group.max_instances
  od_asg_desired_instances = local.app_data.od_config.auto_scaling_group.desired_instances

  spot_instance_type         = local.app_data.spot_config.instance_type
  spot_asg_min_instances     = local.app_data.spot_config.auto_scaling_group.min_instances
  spot_asg_max_instances     = local.app_data.spot_config.auto_scaling_group.max_instances
  spot_asg_desired_instances = local.app_data.spot_config.auto_scaling_group.desired_instances
}
