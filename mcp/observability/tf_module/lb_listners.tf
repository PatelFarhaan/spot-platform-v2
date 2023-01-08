// Listener on port 80
resource "aws_lb_listener" "port_80" {
  port              = 80
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      query       = "query"
      protocol    = "HTTPS"
      host        = "#{host}"
      path        = "/#{path}"
      status_code = "HTTP_301"
    }
  }
}


// Listener on port 443
resource "aws_lb_listener" "port_443" {
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
  certificate_arn   = aws_acm_certificate.mcp_observability_app_certs.arn

  depends_on = [
    aws_acm_certificate.mcp_observability_app_certs,
    aws_route53_record.mcp_observability_acm_records
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_80.arn
  }
}


// Listener on port 9090 for Prometheus
resource "aws_lb_listener" "port_9090" {
  port              = 9090
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
  certificate_arn   = aws_acm_certificate.mcp_observability_app_certs.arn

  depends_on = [
    aws_acm_certificate.mcp_observability_app_certs,
    aws_route53_record.mcp_observability_acm_records
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_9090.arn
  }
}


// Listener on port 9090 for Alert Manager
resource "aws_lb_listener" "port_9093" {
  port              = 9093
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
  certificate_arn   = aws_acm_certificate.mcp_observability_app_certs.arn

  depends_on = [
    aws_acm_certificate.mcp_observability_app_certs,
    aws_route53_record.mcp_observability_acm_records
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_9093.arn
  }
}
