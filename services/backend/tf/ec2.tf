// Defining the ec2 instance
resource "aws_instance" "ec2_instance" {
  tenancy              = "default"
  ami                  = local.config_data.ami_id
  key_name             = local.config_data.key_name
  instance_type        = local.config_data.instance_type
  security_groups      = [aws_security_group.app_sg.name]
  iam_instance_profile = aws_iam_role.iam_role_for_service.name

  monitoring                           = false
  instance_initiated_shutdown_behavior = "stop"

  tags = local.config_data.tags
}
