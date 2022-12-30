output "aws_s3_mcp_bucket_name" {
  value = aws_s3_bucket.mcp_bucket.bucket
}

output "aws_s3_worker_bucket_name" {
  value = aws_s3_bucket.worker_bucket.bucket
}

output "aws_s3_tfstate_bucket_name" {
  value = aws_s3_bucket.tfstate_bucket.bucket
}

output "aws_s3_tfstate_dynamodb_name" {
  value = aws_dynamodb_table.tfstate_dynamodb_table.name
}

output "aws_ecr_id" {
  value = aws_ecr_repository.apps_private_repo.repository_url
}

output "global_lb_security_group_id" {
  value = aws_security_group.global_lb_security_group.id
}
