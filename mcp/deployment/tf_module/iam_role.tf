// Creating a IAM Role with all policies
resource "aws_iam_role" "iam_role_for_service" {
  name = var.regional_name
  managed_policy_arns = [
    aws_iam_policy.mcp_deployment_access.arn
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}


// Creating IAM Profile to be associated with EC2
resource "aws_iam_instance_profile" "iam_profile_for_service" {
  name = "${var.regional_name}-ip"
  role = aws_iam_role.iam_role_for_service.name
}
