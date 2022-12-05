// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "bios-tfstates-bucket"
    dynamodb_table = "mcp-terraform-state-lock"
    key            = "backend/terraform.tfstate"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = jsondecode(file("./../config.json"))
}

module "s1-backend-us-east-1" {
  source = "./tf_module"

  env                = local.config_data.env
  tags               = local.config_data.tags
  region             = local.config_data.region
  ami_id             = local.config_data.ami_id
  vpc_id             = local.config_data.vpc_id
  zone_id            = local.config_data.zone_id
  subnets            = local.config_data.subnets
  key_name           = local.config_data.key_name
  dns_name           = local.config_data.dns_name
  mcp_sg_id          = local.config_data.mcp_sg_id
  prefix_name        = local.config_data.prefix_name
  instance_type      = local.config_data.instance_type
  ebs_volume_size    = local.config_data.ebs_volume_size
  certificate_arn    = local.config_data.certificate_arn
  sns_subscriptions  = local.config_data.sns_subscriptions
  lb_algorithm_type  = local.config_data.lb_algorithm_type
  alb_security_group = local.config_data.security_groups.alb.ingress
  name               = "${local.config_data.service}-${local.config_data.app}-${local.config_data.env}"

  od_instance_type         = local.config_data.od_config.instance_type
  od_asg_min_instances     = local.config_data.od_config.auto_scaling_group.min_instances
  od_asg_max_instances     = local.config_data.od_config.auto_scaling_group.max_instances
  od_asg_desired_instances = local.config_data.od_config.auto_scaling_group.desired_instances

  spot_instance_type         = local.config_data.spot_config.instance_type
  spot_asg_min_instances     = local.config_data.spot_config.auto_scaling_group.min_instances
  spot_asg_max_instances     = local.config_data.spot_config.auto_scaling_group.max_instances
  spot_asg_desired_instances = local.config_data.spot_config.auto_scaling_group.desired_instances
}
