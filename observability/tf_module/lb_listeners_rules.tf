// Forwarding port 443 traffic to Target Group port 80 (Instance port)
resource "aws_alb_listener_rule" "port_443_rule" {
  listener_arn = data.aws_lb_listener.global_mcp_lb_443_listener.arn

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
  listener_arn = data.aws_lb_listener.global_mcp_lb_9090_listener.arn

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
  listener_arn = data.aws_lb_listener.global_mcp_lb_9093_listener.arn

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
