// Creating the ASG for OnDemand instances
resource "aws_autoscaling_group" "on_demand_autoscaling_group" {
  name                 = "${var.name}-od"
  termination_policies = ["OldestInstance"]
  min_size             = var.od_asg_min_instances
  max_size             = var.od_asg_max_instances
  desired_capacity     = var.od_asg_desired_instances
  vpc_zone_identifier  = data.aws_lb.global_dev_apps_load_balancer.subnets
  target_group_arns    = [for target_group in aws_lb_target_group.target_group : target_group.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.od_launch_template.id
        version            = aws_launch_template.od_launch_template.latest_version
      }

      dynamic "override" {
        for_each = var.od_instance_type
        content {
          instance_type = override.value
        }
      }

    }
  }

  default_cooldown          = 15
  default_instance_warmup   = 30
  health_check_grace_period = 120
  capacity_rebalance        = true
  health_check_type         = "ELB"

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    triggers = ["tag"]
    strategy = "Rolling"

    preferences {
      checkpoint_delay       = 15
      min_healthy_percentage = 90
    }
  }

  tag {
    key                 = "Type"
    value               = "On-Demand"
    propagate_at_launch = true
  }

  tag {
    propagate_at_launch = true
    key                 = "Name"
    value               = "${var.name}-od"
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
