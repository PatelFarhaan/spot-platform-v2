// Creating SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "deployment_subscriptions" {
  count = length(local.config_data.sns_subscriptions)

  topic_arn = aws_sns_topic.sns_for_codedeploy.arn
  protocol  = local.config_data.sns_subscriptions[count.index]["protocol"]
  endpoint  = local.config_data.sns_subscriptions[count.index]["endpoint"]
}