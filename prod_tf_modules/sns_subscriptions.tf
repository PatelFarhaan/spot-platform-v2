// Creating SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "deployment_subscriptions" {
  count = length(var.sns_subscriptions)

  topic_arn = aws_sns_topic.sns_for_codedeploy.arn
  protocol  = var.sns_subscriptions[count.index]["protocol"]
  endpoint  = var.sns_subscriptions[count.index]["endpoint"]
}
