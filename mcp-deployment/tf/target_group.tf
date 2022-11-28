// creating a Target Group
resource "aws_lb_target_group" "target_group" {
  port                          = 80
  protocol                      = "HTTP"
  target_type                   = "instance"
  vpc_id                        = "vpc-08da13046fc0ea8fc"
  name                          = "jenkins-tg"
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay          = 100

  health_check {
    path                = "/"
    timeout             = 5
    interval            = 30
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance" {
  port             = 80
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group.arn
}