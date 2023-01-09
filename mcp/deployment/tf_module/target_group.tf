// Target Group for port 80 (Jenkins)
resource "aws_lb_target_group" "target_group_port_80" {
  port                          = 80
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.app}-jenkins"
  vpc_id                        = data.aws_lb.global_dev_apps_load_balancer.vpc_id

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


// Target Group for port 8200 (Vault)
resource "aws_lb_target_group" "target_group_port_8200" {
  port                          = 8200
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.app}-vault"
  vpc_id                        = data.aws_lb.global_dev_apps_load_balancer.vpc_id

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
