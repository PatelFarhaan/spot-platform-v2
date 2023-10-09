variable "tags" {
  type = map(string)
}

variable "sns_subscriptions" {
  type = list(map(string))
}

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
variable "global_name" {}
variable "volume_type" {}
variable "prefix_name" {}
variable "ebs_volume_size" {}
variable "spot_plane_bucket" {}
variable "lb_algorithm_type" {}
variable "client_defined_policies" {}
variable "internal_s3_worker_bucket" {}
variable "internal_s3_spot_plane_bucket" {}
variable "global_dev_apps_load_balancer_arn" {}

# OD vars
variable "od_instance_type" {
  type = list(string)
}
variable "od_asg_min_instances" {}
variable "od_asg_max_instances" {}
variable "od_asg_desired_instances" {}

# Spot vars
variable "spot_instance_type" {
  type = list(string)
}
variable "spot_asg_min_instances" {}
variable "spot_asg_max_instances" {}
variable "spot_asg_desired_instances" {}
