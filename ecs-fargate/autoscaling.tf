resource "aws_appautoscaling_target" "TARGET" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ECS_CLUSTER}/${aws_ecs_service.ECS_SERVICE.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "UP" {
  name               = "cb_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ECS_CLUSTER}/${aws_ecs_service.ECS_SERVICE.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.TARGET]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "DOWN" {
  name               = "cb_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ECS_CLUSTER}/${aws_ecs_service.ECS_SERVICE.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.TARGET]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "SERVICE_CPU_HIGH" {
  alarm_name          = "cb_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = var.ECS_CLUSTER
    ServiceName = aws_ecs_service.ECS_SERVICE.name
  }

  alarm_actions = [aws_appautoscaling_policy.UP.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "SERVICE_CPU_LOW" {
  alarm_name          = "cb_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = var.ECS_CLUSTER
    ServiceName = aws_ecs_service.ECS_SERVICE.name
  }

  alarm_actions = [aws_appautoscaling_policy.DOWN.arn]
}