// creating a Target Group
resource "aws_lb_target_group" "global_mcp_apps_target_group" {
  port                          = 80
  deregistration_delay          = 120
  protocol                      = "HTTP"
  target_type                   = "instance"
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = "least_outstanding_requests"
  name                          = "${var.global_mcp_apps_lb}-${var.region}"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
