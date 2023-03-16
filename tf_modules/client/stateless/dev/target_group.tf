// creating a Target Group
resource "aws_lb_target_group" "target_group" {
  port                          = 80
  deregistration_delay          = 120
  protocol                      = "HTTP"
  name                          = var.name
  target_type                   = "instance"
  load_balancing_algorithm_type = var.lb_algorithm_type
  vpc_id                        = data.aws_lb.global_dev_apps_load_balancer.vpc_id

  lifecycle {
    create_before_destroy = true
  }

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

  tags = var.tags
}
