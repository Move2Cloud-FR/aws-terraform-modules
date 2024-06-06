resource "aws_ecs_service" "ECS_SERVICE" {
  name                                = "${var.APP_NAME}_${var.ENV_PREFIX}_SERVICE"
  cluster                             = var.ECS_CLUSTER
  task_definition                     = aws_ecs_task_definition.ECS_TASK_DEFINITION.arn
  desired_count                       = var.NB_REPLICAS
  launch_type                         = "FARGATE"
  enable_execute_command              = true
  deployment_maximum_percent          = 100
  deployment_minimum_healthy_percent  = 0

  network_configuration {
    security_groups  = [aws_security_group.ECS_TASKS_SG.id]
    subnets          = var.SUBNETS_IDS
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP.arn
    container_name   = var.APP_NAME
    container_port   = var.HTTP_APP_PORT
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb_target_group.ALB_TARGET_GROUP]
}