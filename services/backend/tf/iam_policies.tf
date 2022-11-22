// SES Policy for EC2 Role
resource "aws_iam_role_policy_attachment" "ses_policy_for_ec2_role" {
  role       = aws_iam_role.iam_role_for_ec2_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}


// S3 Policy for EC2 Role
resource "aws_iam_role_policy_attachment" "s3_policy_cd_role" {
  role       = aws_iam_role.iam_role_for_ec2_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


// CodeDeploy Policy for CD Role
resource "aws_iam_role_policy_attachment" "codedeploy_policy_cd_role" {
  role       = aws_iam_role.iam_role_for_codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}