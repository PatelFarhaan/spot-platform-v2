// Creating an S3 bucket for Vault
resource "aws_s3_bucket" "vault_bucket" {
  bucket = var.vault_bucket

  tags = var.tags
}


// Updating the bucket policy as private
resource "aws_s3_bucket_acl" "vault_bucket_acl" {
  bucket = aws_s3_bucket.vault_bucket.id
  acl    = "private"
}


// Enabling versioning of S3 bucket
resource "aws_s3_bucket_versioning" "vault_bucket_versioning" {
  bucket = aws_s3_bucket.vault_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}
