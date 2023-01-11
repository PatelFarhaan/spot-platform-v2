// Fetching details of Global MCP Load Balancer
data "aws_lb" "global_dev_apps_load_balancer" {
  name = var.global_dev_mcp_load_balancer_name
}
