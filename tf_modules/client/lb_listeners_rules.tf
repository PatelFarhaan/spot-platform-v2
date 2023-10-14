// Forwarding Traffic to Secure Port
resource "aws_alb_listener_rule" "secure_port" {
  for_each = {for dns in var.routing : dns["name"] => dns}

  listener_arn = each.value["servicePorts"]["external"] == 80 ? data.aws_lb_listener.global_lb_443_listener.arn : aws_lb_listener.global_lb_additional_listeners[each.key].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
  }

  condition {
    host_header {
      values = [
        each.value["dnsName"],
        "www.${each.value["dnsName"]}"
      ]
    }
  }

  tags = merge(local.tags,
    {
      "Name" = var.name
    }
  )
}
