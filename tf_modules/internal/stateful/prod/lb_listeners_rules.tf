// Forwarding port 443 traffic to Target Group port 80 (Instance port)
resource "aws_alb_listener_rule" "port_443_rule" {
  for_each = {for dns in var.dns_names : dns["name"] => dns}

  listener_arn = data.aws_lb_listener.global_mcp_lb_443_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_ports[each.key].arn
  }

  condition {
    host_header {
      values = [
        each.value["dns"],
        "www.${each.value["dns"]}"
      ]
    }
  }

  tags = var.tags
}
