// SES Policy
resource "aws_iam_policy" "ec2_read_only" {
  description = "EC2 Read only access"
  path        = "/${var.app}/${var.env}/"
  name        = "ec2-ro-${var.regional_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ec2:Describe*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:Describe*",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "autoscaling:Describe*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:Describe*",
        "Resource" : "*"
      },
    ]
  })

  tags = var.tags
}
