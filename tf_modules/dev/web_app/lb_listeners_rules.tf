// Forwarding port 80 traffic to application target group
resource "aws_alb_listener_rule" "port_80_rule" {
  listener_arn = data.aws_lb_listener.global_lb_80_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
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


// Forwarding port 443 traffic to application target group
resource "aws_alb_listener_rule" "port_443_rule" {
  listener_arn = data.aws_lb_listener.global_lb_443_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
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
