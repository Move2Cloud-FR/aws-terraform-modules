data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "auto_scale_role" {
  name               = "${var.DB_TABLE_NAME}-autoscaling-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "autoscaler" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:UpdateTable",
    ]

    resources = ["${aws_dynamodb_table.dbtable.arn}"]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "autoscaler" {
  name   = "${var.DB_TABLE_NAME}-autoscaler-dynamodb"
  role   = aws_iam_role.auto_scale_role.id
  policy = data.aws_iam_policy_document.autoscaler.json
}

data "aws_iam_policy_document" "autoscaler_cloudwatch" {
  statement {
    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
    ]

    resources = ["${aws_dynamodb_table.dbtable.arn}"]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "autoscaler_cloudwatch" {
  name   = "${var.DB_TABLE_NAME}-autoscaler-cloudwatch"
  role   = aws_iam_role.auto_scale_role.id
  policy = data.aws_iam_policy_document.autoscaler_cloudwatch.json
}

resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = var.AUTOSCALE_MAX_READ_CAPACITY
  min_capacity       = var.AUTOSCALE_MIN_READ_CAPACITY
  resource_id        = "table/${aws_dynamodb_table.dbtable.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = aws_iam_role.auto_scale_role.arn
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
  role_arn           = aws_iam_role.auto_scale_role.arn
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