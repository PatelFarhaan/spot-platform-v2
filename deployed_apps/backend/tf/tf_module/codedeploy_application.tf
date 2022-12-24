// Defininf application for CodeDeploy
resource "aws_codedeploy_app" "service_codedeploy_app" {
  name = var.name

  tags = var.tags
}
