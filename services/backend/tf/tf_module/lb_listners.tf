// create a public listner on port 80
resource "aws_lb_listener" "port_80" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.load_balancer.arn

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

  tags = var.tags
}


// create a secure listner on port 443
resource "aws_lb_listener" "port_443" {
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  load_balancer_arn = aws_lb.load_balancer.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = var.tags
}