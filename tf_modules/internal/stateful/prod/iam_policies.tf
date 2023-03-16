// SES Policy
resource "aws_iam_policy" "mcp_deployment_access" {
  name        = var.regional_name
  description = "MCP deployment access"
  path        = "/${var.app}/${var.env}/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : var.policy_list
  })

  tags = var.tags
}
