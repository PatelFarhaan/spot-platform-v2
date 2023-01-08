// Redirecting port 80 traffic to port 443
resource "aws_alb_listener_rule" "port_80_rule" {
  listener_arn = aws_lb_listener.port_80.arn

  action {
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

  condition {
    host_header {
      values = [
        var.dns_name,
        "www.${var.dns_name}"
      ]
    }
  }

  tags = var.tags
}


// Forwarding port 443 traffic to Target Group port 80 (Instance port)
resource "aws_alb_listener_rule" "port_443_rule" {
  listener_arn = aws_lb_listener.port_443.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_80.arn
  }

  condition {
    host_header {
      values = [
        var.dns_name,
        "www.${var.dns_name}"
      ]
    }
  }

  tags = var.tags
}

// Forwarding port 443 traffic to Target Group port 9090 (Instance port)
resource "aws_alb_listener_rule" "port_9090_rule" {
  listener_arn = aws_lb_listener.port_9090.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_9090.arn
  }

  condition {
    host_header {
      values = [
        var.dns_name,
        "www.${var.dns_name}"
      ]
    }
  }

  tags = var.tags
}


// Forwarding port 443 traffic to Target Group port 9093 (Instance port)
resource "aws_alb_listener_rule" "port_9093_rule" {
  listener_arn = aws_lb_listener.port_9093.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_9093.arn
  }

  condition {
    host_header {
      values = [
        var.dns_name,
        "www.${var.dns_name}"
      ]
    }
  }

  tags = var.tags
}
