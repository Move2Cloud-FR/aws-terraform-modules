# ECS Cluster
resource "aws_ecs_cluster" "ECS_CLUSTER" {
  name = "${var.APP_NAME}-${var.ENV_PREFIX}-cluster"
  tags = merge(
    local.local_tags,
    var.CUSTOMER_TAGS
  )
}

# ECS Service
resource "aws_ecs_service" "ECS_SERVICE" {
  name            = "${var.APP_NAME}-${var.ENV_PREFIX}-service"
  cluster         = aws_ecs_cluster.ECS_CLUSTER.name
  task_definition = aws_ecs_task_definition.ECS_TASK_DEFINITION.arn
  desired_count   = var.NB_REPLICAS
  launch_type     = "FARGATE"
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    security_groups  = [aws_security_group.ECS_SERVICE_SG.id]
    subnets          = var.PRIVATE_APP_SUBNETS_IDS
    assign_public_ip = false
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP.arn
    container_name   = var.CONTAINER_NAME
    container_port   = var.CONTAINER_PORT
  }

  tags = merge(
    local.local_tags,
    var.CUSTOMER_TAGS
  )
}