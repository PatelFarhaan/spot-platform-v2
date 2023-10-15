variable "app" {}
variable "env" {}
variable "name" {}
variable "ami_id" {}
variable "region" {}
variable "ecr_mcp" {}
variable "routing" {}
variable "key_name" {}
variable "zone_name" {}
variable "mcp_sg_id" {}
variable "od_config" {}
variable "autoscaling" {}
variable "statefulset" {}
variable "global_name" {}
variable "spot_config" {}
variable "liveness_probe" {}
variable "ebs_volume_size" {}
variable "client_defined_policies" {}
variable "internal_s3_client_app_bucket" {}
variable "internal_s3_spot_plane_bucket" {}
variable "global_dev_apps_load_balancer_arn" {}

variable "tags" {
  type = map(string)
}

variable "sns_subscriptions" {
  type = list(map(string))
}
