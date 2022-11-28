output "aws_s3_tfstate_bucket_name" {
  value = aws_s3_bucket.tfstate_bucket.bucket
}

output "aws_s3_tfstate_dynamodb_name" {
  value = aws_dynamodb_table.tfstate_dynamodb_table.name
}