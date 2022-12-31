// creating a Target Group for port 80
resource "aws_lb_target_group" "target_group_port_80" {
  port                          = 80
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  vpc_id                        = local.config_data.vpc_id
  name                          = "${local.config_data.app}-public"
  load_balancing_algorithm_type = local.config_data.lb_algorithm_type

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
}


// creating a Target Group for port 9090
resource "aws_lb_target_group" "target_group_port_9090" {
  port                          = 9090
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  vpc_id                        = local.config_data.vpc_id
  load_balancing_algorithm_type = local.config_data.lb_algorithm_type
  name                          = "${local.config_data.app}-prometheus"

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
}


// creating a Target Group for port 9093
resource "aws_lb_target_group" "target_group_port_9093" {
  port                          = 9093
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  vpc_id                        = local.config_data.vpc_id
  load_balancing_algorithm_type = local.config_data.lb_algorithm_type
  name                          = "${local.config_data.app}-alert-manager"

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
}
