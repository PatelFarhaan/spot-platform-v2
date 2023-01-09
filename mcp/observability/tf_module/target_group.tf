// Target Group for port 80 (Grafana)
resource "aws_lb_target_group" "target_group_port_80" {
  port                          = 80
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.app}-grafana"
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


// creating a Target Group for port 9090
resource "aws_lb_target_group" "target_group_port_9090" {
  port                          = 9090
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.app}-prometheus"
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


// creating a Target Group for port 9093
resource "aws_lb_target_group" "target_group_port_9093" {
  port                          = 9093
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.app}-alert-manager"
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
