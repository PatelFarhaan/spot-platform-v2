// Defininf application for CodeDeploy
resource "aws_codedeploy_app" "app_codedeploy" {
  name = var.name

  tags = var.tags
}
