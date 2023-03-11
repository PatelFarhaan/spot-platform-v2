// Defining the ec2 instance
resource "aws_instance" "ec2_instance" {
  tenancy              = "default"
  key_name             = var.key_name
  instance_type        = var.instance_type
  ami                  = data.aws_ami.x86_processor.id
  security_groups      = [aws_security_group.app_sg.name]
  iam_instance_profile = aws_iam_instance_profile.iam_profile_for_service.name

  monitoring                           = false
  instance_initiated_shutdown_behavior = "stop"

  tags        = var.tags
  volume_tags = var.tags

  root_block_device {
    volume_size           = 20
    delete_on_termination = true
    volume_type           = "gp3"
  }

  provisioner "file" {
    source      = "${path.module}/../docker_agents"
    destination = "/home/ubuntu"

    connection {
      port        = 22
      agent       = true
      timeout     = "5m"
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.ec2_instance.public_ip
      private_key = file("./../${var.private_key_name_path}")
    }
  }

  user_data = base64encode(data.template_file.cloud_init_script.rendered)
}
