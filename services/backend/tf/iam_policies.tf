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

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group
#// SES Policy
#resource "aws_iam_policy" "ses_full_access" {
#  description = "Full access to SES"
#  name        = "ses-${local.config_data.name}-${local.config_data.env}"
#  path        = "/${local.config_data.name}/${local.config_data.env}/"
#
#  policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        "Sid" : "",
#        "Effect" : "Allow",
#        "Principal" : {
#          "Service" : "codedeploy.amazonaws.com"
#        },
#        "Action" : "sts:AssumeRole"
#      }
#    ]
#  })
#
#  tags = local.config_data.tags
#}