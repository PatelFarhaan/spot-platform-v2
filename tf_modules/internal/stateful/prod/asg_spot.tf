// Creating the ASG for Spot instances
resource "aws_autoscaling_group" "spot_autoscaling_group" {
  name                 = "${var.name}-spot"
  termination_policies = ["OldestInstance"]
  availability_zones   = var.availability_zones
  min_size             = var.spot_asg_min_instances
  max_size             = var.spot_asg_max_instances
  desired_capacity     = var.spot_asg_desired_instances
  target_group_arns    = [for target_group in aws_lb_target_group.target_group_ports : target_group.arn]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "price-capacity-optimized"
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
  default_instance_warmup   = 500
  health_check_grace_period = 400
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

  depends_on = [
    aws_ebs_volume.ebs_multi_attach
  ]

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
        key = "MultiAttachEbsId"
        propagate_at_launch = true
        value = aws_ebs_volume.ebs_multi_attach.id
      },
      {
        key = "MultiAttachEbsSize"
        propagate_at_launch = true
        value = "${aws_ebs_volume.ebs_multi_attach.size}G"
      },
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
