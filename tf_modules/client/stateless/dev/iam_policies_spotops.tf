// Spot Plane Custom Policies for Instances
resource "aws_iam_policy" "ec2_spotops_policy" {
  description = "Additional policies for spotop instances"
  name        = "${var.global_name}-spotops-policies-for-ec2"

  lifecycle {
    create_before_destroy = true
  }

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Resource" : "*"
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DetachInstances"
        ],
      },
      {
        "Resource" : "*"
        "Effect" : "Allow",
        "Action" : [
          "ec2:Describe*",
          "ec2:ModifyVolume"
        ],
      },
      {
        "Resource" : "*"
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
        ],
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.internal_s3_worker_bucket}",
          "arn:aws:s3:::${var.internal_s3_worker_bucket}/${var.env}/${var.app}/*",
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.internal_s3_spot_plane_bucket}",
          "arn:aws:s3:::${var.internal_s3_spot_plane_bucket}/worker_agents/*",
        ]
      }
    ]
  })
}


// Spot Plane Custom Policies for Code Deploy
resource "aws_iam_policy" "codedeploy_spotops_policy" {
  description = "Additional policies for spotops CD"
  name        = "${var.global_name}-spotops-policy-for-codedeploy"

  lifecycle {
    create_before_destroy = true
  }

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Resource" : "*",
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish",
          "tag:GetResources",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances",
          "autoscaling:PutWarmPool",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricAlarm",
          "ec2:DescribeInstanceStatus",
          "autoscaling:ResumeProcesses",
          "autoscaling:PutLifecycleHook",
          "autoscaling:DescribePolicies",
          "autoscaling:SuspendProcesses",
          "autoscaling:PutScalingPolicy",
          "autoscaling:DeleteLifecycleHook",
          "autoscaling:AttachLoadBalancers",
          "autoscaling:DescribeLifecycleHooks",
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:EnableMetricsCollection",
          "autoscaling:DescribeScheduledActions",
          "elasticloadbalancing:RegisterTargets",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeScalingActivities",
          "elasticloadbalancing:DeregisterTargets",
          "autoscaling:PutNotificationConfiguration",
          "autoscaling:PutScheduledUpdateGroupAction",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "autoscaling:RecordLifecycleActionHeartbeat",
          "autoscaling:AttachLoadBalancerTargetGroups",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeInstanceHealth",
          "autoscaling:DescribeNotificationConfigurations",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer"
        ],
      }
    ]
  })
}
