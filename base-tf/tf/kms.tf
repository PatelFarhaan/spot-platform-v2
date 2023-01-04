data "aws_caller_identity" "current" {}


locals {
  account_id = data.aws_caller_identity.current.account_id
}


resource "aws_kms_key" "vault_auto_unseal" {
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  description              = local.config_data.kms_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow administration of the key",
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::${local.account_id}:root" },
        "Action" : [
          "kms:Put*",
          "kms:Get*",
          "kms:List*",
          "kms:Create*",
          "kms:Enable*",
          "kms:Delete*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Describe*",
          "kms:CancelKeyDeletion",
          "kms:ScheduleKeyDeletion"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::${local.account_id}:root" },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:DescribeKey",
          "kms:GenerateDataKey*"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = local.config_data.tags
}


resource "aws_kms_alias" "vault_auto_unseal_name" {
  target_key_id = aws_kms_key.vault_auto_unseal.key_id
  name          = "alias/${local.config_data.kms_name}"
}
