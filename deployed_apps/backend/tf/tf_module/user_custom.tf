// SES Policy for EC2 Role
resource "aws_iam_role_policy_attachment" "ses_policy_for_ec2_role" {
  role       = aws_iam_role.iam_role_for_ec2_application.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}
