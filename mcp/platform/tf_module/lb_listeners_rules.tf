// Forwarding port 443 traffic to Target Group port 80 (Instance port)
resource "aws_alb_listener_rule" "port_443_rule" {
  count = length(var.dns_names)

  listener_arn = data.aws_lb_listener.global_mcp_lb_443_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_ports[count.index].arn
  }

  condition {
    host_header {
      values = [
        var.dns_names[count.index]["dns"],
        "www.${var.dns_names[count.index]["dns"]}"
      ]
    }
  }

  tags = var.tags
}
