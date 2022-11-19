// SES Policy
resource "aws_iam_policy" "ses_full_access" {
  description = "Full access to SES"
  name        = "ses-${local.config_data.name}-${local.config_data.env}"
  path        = "/${local.config_data.name}/${local.config_data.env}/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ses:*"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = local.config_data.tags
}