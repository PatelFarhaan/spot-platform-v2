// Forwarding port 443 traffic to Target Group port 80 (Instance port)
resource "aws_alb_listener_rule" "port_443_rule_for_jenkins" {
  listener_arn = data.aws_lb_listener.global_mcp_lb_443_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_80.arn
  }

  condition {
    host_header {
      values = [
        var.dns_name_jenkins,
        "www.${var.dns_name_jenkins}"
      ]
    }
  }

  tags = var.tags
}


// Forwarding port 443 traffic to Target Group port 80 (Instance port)
resource "aws_alb_listener_rule" "port_443_rule_for_vault" {
  listener_arn = data.aws_lb_listener.global_mcp_lb_443_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_port_8200.arn
  }

  condition {
    host_header {
      values = [
        var.dns_name_vault,
        "www.${var.dns_name_vault}"
      ]
    }
  }

  tags = var.tags
}
