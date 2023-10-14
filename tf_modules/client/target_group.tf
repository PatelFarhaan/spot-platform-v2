// Target Groups
resource "aws_lb_target_group" "target_group" {
  for_each = {for dns in var.routing : dns["name"] => dns}

  deregistration_delay          = 100
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "least_outstanding_requests"
  port                          = each.value["servicePorts"]["internal"]
  vpc_id                        = data.aws_lb.global_dev_apps_load_balancer.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 70
    enabled             = true
    matcher             = "200"
    protocol            = "HTTP"
    interval            = var.liveness_probe["periodSeconds"]
    path                = var.liveness_probe["httpGet"]["path"]
    port                = var.liveness_probe["httpGet"]["port"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags,
    {
      "Name" = var.name
    }
  )
}
