// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "biosmesh-tf-state"
    dynamodb_table = "biosmesh-dynamodb-tflock-state"
    key            = "development/backend/terraform.tfstate"
  }
}


// Reading data variables
locals {
  app_config      = yamldecode(file("./../config.yml"))
  cluster_config  = yamldecode(file("./../config/cluster_config.json"))
  platform_config = yamldecode(file("./../config/platform_config.yml"))
}


module "development-backend-us-east-1" {
  source = "../../../tf_modules/client"

  app                               = local.app_config.name
  tags                              = local.app_config.tags
  sns_subscriptions                 = local.app_config.alerts
  region                            = local.app_config.region
  routing                           = local.app_config.routing
  ami_id                            = local.platform_config.AMI_ID
  key_name                          = local.platform_config.SSH_KEY_NAME
  client_defined_policies           = local.app_config.iam.policy_definition
  statefulset                       = local.app_config.deployment.statefulset
  zone_name                         = local.cluster_config.global_zone_name_1
  env                               = local.app_config.deployment.environment
  ebs_volume_size                   = local.app_config.deployment.baseDiskSize
  liveness_probe                    = local.app_config.deployment.livenessProbe
  mcp_sg_id                         = local.platform_config.OBSERVABILITY_SG_ID
  global_dev_apps_load_balancer_arn = local.cluster_config.global_dev_apps_lb_arn
  autoscaling                       = local.app_config.deployment.autoScalingGroup
  ecr_mcp                           = local.platform_config.INTERNAL_APPS_REGISTRY
  internal_s3_worker_bucket         = local.cluster_config.s3_mcp_worker_bucket_name
  od_config                         = local.app_config.deployment.autoScalingGroup.od
  spot_config                       = local.app_config.deployment.autoScalingGroup.spot
  internal_s3_spot_plane_bucket     = local.cluster_config.s3_mcp_spot_plane_bucket_name
  name                              = "biosmesh-${local.app_config.deployment.environment}-${local.app_config.name}"
  global_name                       = "biosmesh-${local.app_config.deployment.environment}-${local.app_config.name}-${local.app_config.region}"
}
