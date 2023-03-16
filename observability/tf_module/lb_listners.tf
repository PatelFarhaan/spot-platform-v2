// Fetching details of Global Load Balancer Listener for port 80
data "aws_lb_listener" "global_mcp_lb_80_listener" {
  port              = 80
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}


// Fetching details of Global Load Balancer Listener for port 443
data "aws_lb_listener" "global_mcp_lb_443_listener" {
  port              = 443
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}


// Fetching details of Global Load Balancer Listener for port 9090
data "aws_lb_listener" "global_mcp_lb_9090_listener" {
  port              = 9090
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}


// Fetching details of Global Load Balancer Listener for port 9093
data "aws_lb_listener" "global_mcp_lb_9093_listener" {
  port              = 9093
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}
