resource "aws_kms_key" "vault_auto_unseal" {
  description             = local.config_data.kms_name
  deletion_window_in_days = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage = "ENCRYPT_DECRYPT"
  policy = ""

  tags = local.config_data.tags
}


# TODO: Policy
