// Creating the ASG for Spot instances
resource "aws_autoscaling_group" "spot_autoscaling_group" {
  name                 = "${var.name}-spot"
  termination_policies = ["OldestInstance"]
  min_size             = var.spot_asg_min_instances
  max_size             = var.spot_asg_max_instances
  desired_capacity     = var.spot_asg_desired_instances
  target_group_arns    = [aws_lb_target_group.target_group.arn]
  vpc_zone_identifier  = data.aws_lb.global_dev_apps_load_balancer.subnets

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_instance_pools                      = 20
      spot_allocation_strategy                 = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.spot_launch_template.id
        version            = aws_launch_template.spot_launch_template.latest_version
      }

      dynamic "override" {
        for_each = var.spot_instance_type
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

  # TODO: Make this dynamic

  tags = concat(
    [
      for key, value in var.tags :
      {
        key                 = key
        value               = value
        propagate_at_launch = true
      }
    ],
    [
      {
        propagate_at_launch = true
        key                 = "Type"
        value               = "Spot"
      },
      {
        propagate_at_launch = true
        key                 = "Name"
        value               = "${var.name}-spot"
      }
    ]
  )
}
