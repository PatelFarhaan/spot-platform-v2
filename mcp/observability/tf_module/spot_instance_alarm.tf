// Alarm for AWS Spot Instances
resource "aws_cloudwatch_metric_alarm" "ec2_spot_instances" {
  alarm_name                = "ec2-spot-instances-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ResourceCount"
  namespace                 = "AWS/Usage"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "This metric monitors Spot Instance Available"
  insufficient_data_actions = []
}
