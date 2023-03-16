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
      {
        Effect = "Allow",
        Action = [
          "s3:*",
        ],
        Resource = [
          "arn:aws:s3:::${var.mcp_spot_bucket}/nfs/",
          "arn:aws:s3:::${var.mcp_spot_bucket}/nfs/*",
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "iam:ListInstanceProfiles"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ],
        Resource = [
          "arn:aws:s3:::${var.mcp_spot_bucket}",
          "arn:aws:s3:::${var.mcp_spot_bucket}/*",
        ]
      }
    ]
  })

  tags = var.tags
}
