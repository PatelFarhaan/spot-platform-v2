// Defining application for CodeDeploy
resource "aws_codedeploy_app" "app_codedeploy" {
  name = var.name

  tags = merge(local.tags,
    {
      "Name" = var.name
    }
  )
}
