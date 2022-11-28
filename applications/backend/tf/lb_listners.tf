// create a public listner on port 80
resource "aws_lb_listener" "port_80" {
  port              = 80
  load_balancer_arn = aws_lb.load_balancer.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      query       = "query"
      host        = "#{host}"
      path        = "/#{path}"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


// create a secure listner on port 443
resource "aws_lb_listener" "port_443" {
  port              = 443
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.load_balancer.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.config_data.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}