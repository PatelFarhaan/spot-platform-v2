// Creating a private ECR repo for the service
resource "aws_ecr_repository" "service_private_repo" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = var.tags
}
