// Fetching details of Global Load Balancer
data "aws_lb" "global_dev_apps_load_balancer" {
  arn = var.global_dev_apps_load_balancer_arn
}
