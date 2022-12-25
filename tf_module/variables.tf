variable "app" {}
variable "env" {}
variable "tags" {
  type = map(string)
}
variable "name" {}
variable "ami_id" {
}
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {}
variable "region" {}
variable "zone_id" {}
variable "dns_name" {}
variable "key_name" {}
variable "mcp_sg_id" {}
variable "prefix_name" {}
variable "certificate_arn" {}
variable "ebs_volume_size" {}
variable "sns_subscriptions" {
  type = list(map(string))
}
variable "spot_instance_type" {
  type = list(string)
}
variable "lb_algorithm_type" {}
variable "alb_security_group" {}
variable "client_defined_policies" {}
variable "internal_s3_worker_bucket" {}
variable "internal_s3_spot_plane_bucket" {}

# OD vars
variable "od_instance_type" {}
variable "od_asg_min_instances" {}
variable "od_asg_max_instances" {}
variable "od_asg_desired_instances" {}

# Spot vars
variable "spot_asg_min_instances" {}
variable "spot_asg_max_instances" {}
variable "spot_asg_desired_instances" {}