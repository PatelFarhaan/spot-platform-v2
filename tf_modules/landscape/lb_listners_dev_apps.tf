// Public listener on port 80
resource "aws_lb_listener" "dev_apps_port_80" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.global_dev_apps_lb.arn

  depends_on = [aws_lb_target_group.global_dev_apps_target_group]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.global_dev_apps_target_group.arn
  }

  tags = var.tags
}


// Secure listener on port 443
resource "aws_lb_listener" "dev_apps_port_443" {
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  load_balancer_arn = aws_lb.global_dev_apps_lb.arn
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs,
    aws_lb_target_group.global_dev_apps_target_group
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.global_dev_apps_target_group.arn
  }

  tags = var.tags
}
