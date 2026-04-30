# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "TASK_LOG_GROUP" {
  name              = "/ecs/${var.APP_NAME}"
  retention_in_days = 30

  tags = {
    Name = "${var.APP_NAME}-log-group"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_cloudwatch_log_stream" "TASK_LOG_STREAM" {
  name           = "${var.APP_NAME}-log-stream"
  log_group_name = aws_cloudwatch_log_group.TASK_LOG_GROUP.name
}
