// Creating an SNS topic for CodeDeploy notifications
resource "aws_sns_topic" "sns_for_codedeploy" {
  name = var.name

  tags = var.tags
}