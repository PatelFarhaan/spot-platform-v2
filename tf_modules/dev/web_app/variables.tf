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
variable "zone_id" {}
variable "dns_name" {}
variable "key_name" {}
variable "mcp_sg_id" {}
variable "global_name" {}
variable "volume_type" {}
variable "prefix_name" {}
variable "ebs_volume_size" {}
variable "lb_algorithm_type" {}
variable "client_defined_policies" {}
variable "global_load_balancer_arn" {}
variable "internal_s3_worker_bucket" {}
variable "internal_s3_spot_plane_bucket" {}

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