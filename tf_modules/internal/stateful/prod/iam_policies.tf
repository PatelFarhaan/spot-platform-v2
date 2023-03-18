// IAM Policies
resource "aws_iam_policy" "mcp_deployment_access" {
  name        = var.regional_name
  description = "MCP Internal Access"
  path        = "/${var.app}/${var.env}/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : local.iam_policies
  })

  tags = var.tags
}
