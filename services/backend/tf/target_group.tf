// creating a Target Group
resource "aws_lb_target_group" "target_group" {
  port                          = 80
  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  name                          = local.config_data.name
  vpc_id                        = local.config_data.vpc_id
  load_balancing_algorithm_type = local.config_data.lb_algorithm_type

  health_check {
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    path                = "/"
    matcher             = "404"
    protocol            = "HTTP"
  }

  tags = local.config_data.tags
}

// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance" {
  port             = 80
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group.arn
}