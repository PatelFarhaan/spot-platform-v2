resource "aws_iam_role" "iam_role_for_codedeploy" {
  name = "${var.name}-${var.region}-cd"

  managed_policy_arns = [
    aws_iam_policy.codedeploy_spotops_policy.arn
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com",
            "codedeploy.${var.region}.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}