// Creating Launch Config for OnDemand instances
resource "aws_launch_configuration" "on_demand_launch_configuration" {
  name_prefix          = "od-"
  image_id             = var.ami_id
  key_name             = var.key_name
  instance_type        = var.od_instance_type
  security_groups      = [aws_security_group.app_sg.id]
  user_data            = base64encode(data.template_file.spotops_user_data.rendered)
  iam_instance_profile = aws_iam_instance_profile.iam_profile_for_application.name

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ebs_volume_size
  }

  lifecycle {
    create_before_destroy = true
  }
}


// Creating the ASG for OnDemand instances
resource "aws_autoscaling_group" "on_demand_autoscaling_group" {
  name_prefix          = "od-"
  vpc_zone_identifier  = var.subnets
  min_size             = var.od_asg_min_instances
  max_size             = var.od_asg_max_instances
  termination_policies = ["ClosestToNextInstanceHour"]
  desired_capacity     = var.od_asg_desired_instances
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
      if key != "Name"
    ],
    [
      {
        key                 = "Type"
        value               = "On-Demand"
        propagate_at_launch = true
      },
      {
        key                 = "Name"
        value               = "${var.name}-od"
        propagate_at_launch = true
      }
    ]
  )
}