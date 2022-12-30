// creating a Target Group
resource "aws_lb_target_group" "target_group" {
  port                          = 80
  deregistration_delay          = 120
  protocol                      = "HTTP"
  target_type                   = "instance"
  vpc_id                        = local.config_data.vpc_id
  load_balancing_algorithm_type = local.config_data.lb_algorithm_type
  name                          = "${local.config_data.global_dev_apps_lb_name}-${local.config_data.region}"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.config_data.tags
}
