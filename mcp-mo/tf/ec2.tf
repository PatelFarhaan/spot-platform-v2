// Defining the ec2 instance
resource "aws_instance" "ec2_instance" {
  tenancy         = "default"
  ami             = local.config_data.ami_id
  key_name        = local.config_data.key_name
  instance_type   = local.config_data.instance_type
  security_groups = [aws_security_group.app_sg.name]
  iam_instance_profile = aws_iam_role.iam_role_for_service.arn

  monitoring                           = false
  instance_initiated_shutdown_behavior = "stop"

  tags = local.config_data.tags

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
      private_key = file("./../${local.config_data.private_key_name_path}")
    }
  }

  user_data = base64encode(data.template_file.cloud_init_script.rendered)
}
