// Creating a private ECR Repo for MCP
resource "aws_ecr_repository" "mcp_private_repo" {
  image_tag_mutability = "MUTABLE"
  name                 = var.ecr_mcp

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = var.tags
}
