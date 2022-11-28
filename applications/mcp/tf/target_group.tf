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
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
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
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
  }
}


// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance_port_80" {
  port             = 80
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group_port_80.arn
}


// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance_port_9090" {
  port             = 9090
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group_port_9090.arn
}