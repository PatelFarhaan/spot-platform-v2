// Fetching details of Global MCP Load Balancer
data "aws_lb" "global_mcp_apps_load_balancer" {
  arn = var.global_mcp_load_balancer_arn
}
