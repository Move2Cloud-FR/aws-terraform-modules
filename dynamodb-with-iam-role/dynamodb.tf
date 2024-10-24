resource "aws_dynamodb_table" "dbtable" {
  name           = "${var.DB_TABLE_NAME}"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.AUTOSCALE_MIN_READ_CAPACITY
  write_capacity = var.AUTOSCALE_MIN_WRITE_CAPACITY
  attribute {
    name = "id"
    type = "S"
  }
  
  hash_key = "id"
  
  // adding the TTL on DynamoDB Table
  ttl {
    enabled        = true      // enabling TTL
    attribute_name = "created" // the attribute name which enforces TTL, must be a Number (Timestamp)
  }
  
  // configuring Point in Time Recovery 
  point_in_time_recovery {
    enabled = true
  }
  
  // configure encryption at REST
  server_side_encryption {
    enabled = true // false -> use AWS Owned CMK, true -> use AWS Managed CMK, true + key arn -> use custom key
  }

  lifecycle {
    ignore_changes = [
      write_capacity, read_capacity
    ]
  }
}

// add autoscaling
resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = var.AUTOSCALE_MAX_READ_CAPACITY
  min_capacity       = var.AUTOSCALE_MIN_READ_CAPACITY
  resource_id        = "table/${aws_dynamodb_table.dbtable.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = var.IAM_ROLE_ARN
}

resource "aws_appautoscaling_policy" "read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.AUTOSCALE_READ_TARGET
  }
}

resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = var.AUTOSCALE_MAX_WRITE_CAPACITY
  min_capacity       = var.AUTOSCALE_MIN_WRITE_CAPACITY
  resource_id        = "table/${aws_dynamodb_table.dbtable.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = var.IAM_ROLE_ARN
}

resource "aws_appautoscaling_policy" "write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.AUTOSCALE_WRITE_TARGET
  }
}

