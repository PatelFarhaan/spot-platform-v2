// Creating DynamoDB table for processing TF state locks
resource "aws_dynamodb_table" "tfstate_dynamodb_table" {
  name           = var.dynamodb_name
  billing_mode   = "PROVISIONED"
  hash_key       = "LockID"
  write_capacity = 5
  read_capacity  = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}


// Enabling Autoscaling Target for READ
resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  min_capacity       = 5
  max_capacity       = 50
  service_namespace  = "dynamodb"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  resource_id        = "table/${aws_dynamodb_table.tfstate_dynamodb_table.id}"
}


// Enabling Autoscaling Policy for READ
resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}


// Enabling Autoscaling Target for WRITE
resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  min_capacity       = 5
  max_capacity       = 50
  service_namespace  = "dynamodb"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  resource_id        = "table/${aws_dynamodb_table.tfstate_dynamodb_table.id}"
}


// Enabling Autoscaling Policy for WRITE
resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target.resource_id
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}
