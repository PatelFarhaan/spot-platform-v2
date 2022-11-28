#// S3 Bucket Policy
#resource "aws_iam_policy" "s3_bucket_policy" {
#  description = "Full S3 bucket permission"
#  name        = "artifactory-ha-s3-${var.aws_region}-${var.env}"
#  path        = "/artifactory-ha/${var.env}/${var.aws_region}/artifactory/"
#
#  policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        Effect   = "Allow",
#        Action   = "s3:*",
#        Resource = [
#          "arn:aws:s3:::${aws_s3_bucket.artifactory_s3_bucket.id}/*",
#          "arn:aws:s3:::${aws_s3_bucket.artifactory_s3_bucket.id}",
#        ]
#      }
#    ]
#  })
#}
#
#
#// RDS Policy
#resource "aws_iam_policy" "rds_database_policy" {
#  description = "Full RDS database permission"
#  name        = "artifactory-ha-rds-${var.aws_region}-${var.env}"
#  path        = "/artifactory-ha/${var.env}/${var.aws_region}/artifactory/"
#
#  policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        Effect   = "Allow",
#        Action   = "rds:*",
#        Resource = [
#          "arn:aws:rds:::db:${aws_db_instance.artifactory_postgres_db.id}",
#          "arn:aws:rds:::pg:${aws_db_instance.artifactory_postgres_db.id}",
#          "arn:aws:rds:::subgrp:${aws_db_instance.artifactory_postgres_db.id}",
#        ]
#      }
#    ]
#  })
#}
#
#
#// Creating a IAM Role
#resource "aws_iam_role" "s3_rds_permission_for_artifactory" {
#  name                = "artifactory-ha-${var.aws_region}-${var.env}"
#  managed_policy_arns = [
#    aws_iam_policy.s3_bucket_policy.arn,
#    aws_iam_policy.rds_database_policy.arn
#  ]
#
#  assume_role_policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        Effect    = "Allow",
#        Principal = {
#          Service = "eks.amazonaws.com"
#        },
#        Action    = "sts:AssumeRole"
#      },
#      var.oidc_iam_tr
#    ]
#  })
#
#  tags = merge(var.tags, {
#    "Name"  = var.iam_name_tag
#  })
#}
