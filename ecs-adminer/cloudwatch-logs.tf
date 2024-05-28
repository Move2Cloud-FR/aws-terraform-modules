# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "TASK_LOG_GROUP" {
  name                = "/ecs/${var.APP_NAME}/${var.ENV_PREFIX}"
  retention_in_days   = 30
  tags                = local.local_tags
}

resource "aws_cloudwatch_log_stream" "TASK_LOG_STREAM" {
  name                = "${var.APP_NAME}-${var.ENV_PREFIX}-log-stream"
  log_group_name      = aws_cloudwatch_log_group.TASK_LOG_GROUP.name
}