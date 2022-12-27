// Creating Launch Config for OnDemand instances
resource "aws_launch_configuration" "on_demand_launch_configuration" {
  image_id             = var.ami_id
  key_name             = var.key_name
  name_prefix          = "${var.name}-od-"
  instance_type        = var.od_instance_type
  security_groups      = [aws_security_group.app_sg.id]
  iam_instance_profile = aws_iam_instance_profile.iam_profile_for_application.name
  user_data            = base64encode(data.template_file.spotops_user_data.rendered)

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = var.ebs_volume_size
  }

  lifecycle {
    create_before_destroy = true
  }
}
