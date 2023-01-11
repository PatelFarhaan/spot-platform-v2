// Creating an S3 bucket for storing TF state files
resource "aws_s3_bucket" "mcp_bucket" {
  bucket = var.mcp_bucket

  tags = var.tags
}


// Updating the bucket policy as private
resource "aws_s3_bucket_acl" "mcp_bucket_acl" {
  bucket = aws_s3_bucket.mcp_bucket.id
  acl    = "private"
}


// Enabling versioning of S3 bucket
resource "aws_s3_bucket_versioning" "mcp_bucket_versioning" {
  bucket = aws_s3_bucket.mcp_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
