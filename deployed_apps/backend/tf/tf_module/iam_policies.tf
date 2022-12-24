// S3 Policy for EC2 Role
resource "aws_iam_role_policy_attachment" "s3_policy_cd_role" {
  role       = aws_iam_role.iam_role_for_ec2_application.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


// CodeDeploy Policy for CD Role
resource "aws_iam_role_policy_attachment" "codedeploy_policy_cd_role" {
  role       = aws_iam_role.iam_role_for_codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}


// S3 Bucket Policy
resource "aws_iam_policy" "ec2_spotops_policy" {
  description = "Additional policies for spotops"
  name        = "${var.env}-${var.app}-spotops-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "ec2:Describe*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
    ]
  })
}