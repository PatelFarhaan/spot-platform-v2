// Fetching details of Global Load Balancer Listener for port 80
data "aws_lb_listener" "global_lb_80_listener" {
  load_balancer_arn = data.aws_lb.global_load_balancer.arn
  port              = 80
}


// Fetching details of Global Load Balancer Listener for port 443
data "aws_lb_listener" "global_lb_443_listener" {
  load_balancer_arn = data.aws_lb.global_load_balancer.arn
  port              = 443
}
