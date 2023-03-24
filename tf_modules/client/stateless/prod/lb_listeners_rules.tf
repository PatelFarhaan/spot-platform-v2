// Redirecting naked to non naked domain for port 80
resource "aws_alb_listener_rule" "port_80_rule" {
  listener_arn = aws_lb_listener.port_80.arn

  action {
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

  condition {
    host_header {
      values = [var.dns_name]
    }
  }

  tags = var.tags
}


// Redirecting naked to non naked domain for port 443
resource "aws_alb_listener_rule" "port_443_rule" {
  listener_arn = aws_lb_listener.port_443.arn

  action {
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

  condition {
    host_header {
      values = [var.dns_name]
    }
  }

  tags = var.tags
}
