# ECS Cluster
resource "aws_ecs_cluster" "ECS_CLUSTER" {
  name = "${var.APP_NAME}-${var.ENV_PREFIX}-cluster"
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

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# ECS Service security group
resource "aws_security_group" "ECS_SERVICE_SG" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-ecs-sg"
  vpc_id      = "${var.VPC_ID}"
  description = "ECS ${var.APP_NAME}-${var.ENV_PREFIX}-service security group"

  ingress {
    from_port   = var.CONTAINER_PORT
    to_port     = var.CONTAINER_PORT
    protocol    = "TCP"
    security_groups = ["${aws_security_group.ALB_SG.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV_PREFIX}-ecs-sg"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}