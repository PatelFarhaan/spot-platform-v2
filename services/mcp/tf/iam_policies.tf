// SES Policy
resource "aws_iam_policy" "ec2_read_only" {
  description = "EC2 Read only access"
  name        = "ec2ro-${local.config_data.name}-${local.config_data.env}"
  path        = "/${local.config_data.name}/${local.config_data.env}/"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
})

  tags = local.config_data.tags
}