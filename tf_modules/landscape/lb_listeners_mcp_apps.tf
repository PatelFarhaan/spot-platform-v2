// Redirect all traffic from port 80 to port 443
resource "aws_lb_listener" "mcp_port_80" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.global_mcp_apps_lb.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      path        = "/#{path}"
      status_code = "HTTP_301"
      host        = "www.#{host}"
    }
  }

  tags = var.tags
}


// Secure listener on port 443
resource "aws_lb_listener" "mcp_port_443" {
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  load_balancer_arn = aws_lb.global_mcp_apps_lb.arn
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.global_mcp_apps_target_group.arn
  }

  tags = var.tags
}
