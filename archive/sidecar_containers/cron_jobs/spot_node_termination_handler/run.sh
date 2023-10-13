#!/bin/bash

URL="http://169.254.169.254/latest/meta-data/spot/instance-action"
RESPONSE=$(curl -w "%{http_code}" "$URL" -o /dev/null)

if [ "$RESPONSE" -eq "200" ]; then
  echo "HTTP status code is 200"
  JSON=$(curl -s "$URL" | jq .)
  echo "Response is:"
  echo "$JSON"

  instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  export AWS_REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
  tags=$(aws ec2 describe-tags --region "$AWS_REGION" --filter "Name=resource-id,Values=$instance_id" | jq '.Tags')
  asg=$(echo "$tags" | jq -r '.[] | select(.Key=="aws:autoscaling:groupName") | .Value')
  aws autoscaling detach-instances --region "$AWS_REGION" --instance-ids "$instance_id" --auto-scaling-group-name "$asg" --no-should-decrement-desired-capacity
else
  echo "HTTP status code is not 200"
fi
