// Creating a private ECR Repo
resource "aws_ecr_repository" "apps_private_repo" {
  name                 = local.config_data.ecr_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = local.config_data.tags
}
