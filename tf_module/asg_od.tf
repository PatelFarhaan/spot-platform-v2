// Creating the ASG for OnDemand instances
resource "aws_autoscaling_group" "on_demand_autoscaling_group" {
  vpc_zone_identifier  = var.subnets
  name                 = "${var.name}-od"
  min_size             = var.od_asg_min_instances
  max_size             = var.od_asg_max_instances
  desired_capacity     = var.od_asg_desired_instances
  termination_policies = ["ClosestToNextInstanceHour"]
  target_group_arns    = [aws_lb_target_group.target_group.arn]
  launch_configuration = aws_launch_configuration.on_demand_launch_configuration.name

  default_cooldown          = 15
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
        value               = "On-Demand"
      },
      {
        propagate_at_launch = true
        key                 = "Name"
        value               = "${var.name}-od"
      }
    ]
  )
}