// Defining the ec2 instance
resource "aws_instance" "ec2_instance" {
  tenancy              = "default"
  ami                  = var.ami_id
  key_name             = var.key_name
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.app_sg.name]
  iam_instance_profile = aws_iam_role.iam_role_for_ec2_service.name

  monitoring                           = false
  instance_initiated_shutdown_behavior = "stop"

  tags = var.tags
}
