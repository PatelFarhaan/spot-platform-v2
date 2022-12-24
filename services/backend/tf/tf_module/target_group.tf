// creating a Target Group
resource "aws_lb_target_group" "target_group" {
  port                          = 80
  deregistration_delay          = 10
  protocol                      = "HTTP"
  target_type                   = "instance"
  name                          = var.name
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = var.lb_algorithm_type

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
    path                = "/ping"
    port                = "traffic-port"
  }

  tags = var.tags
}
#
#// register instance for target group
#resource "aws_lb_target_group_attachment" "register_instance" {
#  port             = 80
#  target_id        = aws_instance.ec2_instance.id
#  target_group_arn = aws_lb_target_group.target_group.arn
#}
