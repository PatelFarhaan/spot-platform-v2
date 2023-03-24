// Public listener on port 80
resource "aws_lb_listener" "port_80" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.load_balancer.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      host        = "#{host}"
      query       = "#{query}"
      path        = "/#{path}"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}


// Secure listener on port 443
resource "aws_lb_listener" "port_443" {
  port              = 443
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.load_balancer.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.application_specific_certs.arn

  depends_on = [
    aws_route53_record.application_acm_records,
    aws_acm_certificate.application_specific_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = var.tags
}
