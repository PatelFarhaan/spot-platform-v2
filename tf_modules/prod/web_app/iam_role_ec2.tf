// Creating a IAM Role with all policies
resource "aws_iam_role" "iam_role_for_ec2_application" {
  name = "${var.global_name}-ec2"
  managed_policy_arns = [
    aws_iam_policy.ec2_spotops_policy.arn,
    aws_iam_policy.client_defined_policies.arn
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}


// Creating IAM Profile to be associated with EC2
resource "aws_iam_instance_profile" "iam_profile_for_application" {
  name = "${var.global_name}-spotops-instance-profile"
  role = aws_iam_role.iam_role_for_ec2_application.name

  tags = var.tags
}
