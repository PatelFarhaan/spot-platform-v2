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
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        "Resource" : "arn:aws:kms:::key/${var.kms_id}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.mcp_spot_bucket}",
          "arn:aws:s3:::${var.mcp_spot_bucket}/*",
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.mcp_vault_bucket}",
          "arn:aws:s3:::${var.mcp_vault_bucket}/*",
        ]
      }
    ]
  })

  tags = var.tags
}
