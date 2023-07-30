// Creating an S3 bucket for Static Hosting
resource "aws_s3_bucket" "static_hosting_bucket" {
  bucket = var.static_hosting_bucket

  tags = var.tags
}


// Defining AWS Bucket Policy
resource "aws_s3_bucket_policy" "static_hosting_bucket_policy" {
  bucket = aws_s3_bucket.static_hosting_bucket.id
  depends_on = [aws_s3_bucket.static_hosting_bucket]

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
     {
       "Sid":"AddPerm",
       "Effect":"Allow",
       "Principal": "*",
       "Action":["s3:GetObject"],
       "Resource":["arn:aws:s3:::${aws_s3_bucket.static_hosting_bucket.bucket}/*"]
     }
  ]
}
POLICY
}


// Allow all Public Access to the Bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.static_hosting_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


// Enabling Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "static_hosting_bucket_obj_ownership" {
  bucket = aws_s3_bucket.static_hosting_bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


// Enabling versioning of S3 bucket
resource "aws_s3_bucket_versioning" "static_hosting_bucket_versioning" {
  bucket = aws_s3_bucket.static_hosting_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}
