// Fetching details of Global Load Balancer Listener for port 80
data "aws_lb_listener" "global_lb_80_listener" {
  port              = 80
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}


// Fetching details of Global Load Balancer Listener for port 443
data "aws_lb_listener" "global_lb_443_listener" {
  port              = 443
  load_balancer_arn = data.aws_lb.global_dev_apps_load_balancer.arn
}
