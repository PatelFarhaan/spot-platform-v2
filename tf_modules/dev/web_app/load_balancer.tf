// Fetching details of Global Load Balancer
data "aws_lb" "global_load_balancer" {
  arn = var.global_load_balancer_arn
}
