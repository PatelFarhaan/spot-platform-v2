// Creating a private ECR Repo
resource "aws_ecr_repository" "apps_private_repo" {
  image_tag_mutability = "IMMUTABLE"
  name                 = var.ecr_name

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = var.tags
}
