// Creating Launch Template for OD instances
resource "aws_launch_template" "od_launch_template" {
  update_default_version = true
  image_id               = var.ami_id
  key_name               = var.key_name
  name_prefix            = "${var.name}-od-"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = base64encode(data.template_file.cloud_init_script.rendered)

  monitoring {
    enabled = false
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.iam_profile_for_service.name
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      throughput            = 125
      iops                  = 3000
      delete_on_termination = true
      volume_type           = "gp3"
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
      tags          = merge(
        var.tags,
        {
          "Name" : "${var.name}-od"
        }
      )
    }
  }

  tags = var.tags
}
