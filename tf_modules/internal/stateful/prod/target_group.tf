// Target Groups
resource "aws_lb_target_group" "target_group_ports" {
  #  count = length(var.dns_names)
  for_each = {for dns in var.dns_names : dns["name"] => dns}

  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  name                          = "${var.app}-${each.key}"
  port                          = each.value["internal_port"]
  load_balancing_algorithm_type = "least_outstanding_requests"
  vpc_id                        = data.aws_lb.global_mcp_apps_load_balancer.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 15
    enabled             = true
    matcher             = "200"
    protocol            = "HTTP"
    port                = "9999"
    path                = "/internal/spotops/health"
  }

  lifecycle {
    create_before_destroy = true
  }
}
