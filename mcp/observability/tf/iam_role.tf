// Creating a IAM Role with all policies
resource "aws_iam_role" "iam_role_for_service" {
  name                = "${local.config_data.name}-${local.config_data.env}"
  managed_policy_arns = [
    aws_iam_policy.ec2_read_only.arn
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = local.config_data.tags
}

// Creating IAM Profile to be associated with EC2
resource "aws_iam_instance_profile" "iam_profile_for_service" {
  name = "monitoring_control_plane_development"
  role = aws_iam_role.iam_role_for_service.name
}
