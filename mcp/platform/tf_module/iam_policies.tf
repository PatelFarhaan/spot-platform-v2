// SES Policy
resource "aws_iam_policy" "mcp_deployment_access" {
  name        = var.regional_name
  description = "MCP deployment access"
  path        = "/${var.app}/${var.env}/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "kms:*"
        "Resource" : "*"
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
        Effect   = "Allow",
        Action   = "s3:*"
        Resource = [
          "arn:aws:s3:::${var.mcp_vault_bucket}",
          "arn:aws:s3:::${var.mcp_vault_bucket}/*",
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:*",
          "cloudtrail:LookupEvents"
        ]
        Resource = "*"
      },
      {
        "Action" : "ecr:GetAuthorizationToken",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ec2:DescribeTags",
          "ec2:AttachVolume",
          "ec2:DescribeVolumes"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })

  tags = var.tags
}
