// Creating Launch Template for Spot instances
resource "aws_launch_template" "spot_launch_template" {
  update_default_version = true
  ebs_optimized          = false
  image_id               = var.ami_id
  key_name               = var.key_name
  name_prefix            = "${var.name}-spot-"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = base64encode(data.template_file.spotops_user_data.rendered)

  monitoring {
    enabled = false
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.iam_profile_for_application.name
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_type           = var.volume_type
      volume_size           = var.ebs_volume_size
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  dynamic "tag_specifications" {
    for_each = toset(local.resources)
    content {
      resource_type = tag_specifications.key
      tags = merge(
        var.tags,
        {
          "Name" : "${var.name}-spot"
        }
      )
    }
  }

  tags = var.tags
}
