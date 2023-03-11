// Target Group for port 80 (Jenkins)
resource "aws_lb_target_group" "target_group_ports" {
  count = length(var.dns_names)

  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "least_outstanding_requests"
  port                          = var.dns_names[count.index]["port"]
  vpc_id                        = data.aws_lb.global_dev_apps_load_balancer.vpc_id
  name                          = "${var.app}-${var.dns_names[count.index]["name"]}"

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
    create_before_destroy = false
  }
}
