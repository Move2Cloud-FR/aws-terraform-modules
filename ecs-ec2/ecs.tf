/* Cluster definition */
resource "aws_ecs_cluster" "ECS_CLUSTER" {
  name = "${var.APP_NAME}_${var.ENV_PREFIX}_cluster"

}

/* ECS service definition */
resource "aws_ecs_service" "ECS_SERVICE" {
  name                               = "${var.APP_NAME}_${var.ENV_PREFIX}_SERViICE"
  cluster                            = aws_ecs_cluster.ECS_CLUSTER.id
  task_definition                    = aws_ecs_task_definition.ECS_TASK_DEFINITION.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = var.MINIMUM_HEALTHY_PERCENT
  iam_role                           = aws_iam_role.ECS_SERVICE_ROLE.arn


  load_balancer {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP1.arn
    container_name   = var.APP_NAME
    container_port   = var.APP_PORT
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb_target_group.ALB_TARGET_GROUP1]

}

resource "aws_ecs_task_definition" "ECS_TASK_DEFINITION" {
  family                = "${var.APP_NAME}_${var.ENV_PREFIX}_TASKDEF"
  container_definitions = data.template_file.TEMPLATE.rendered
  execution_role_arn    = var.TASK_EXECUTION_ROLE_ARN

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "TEMPLATE" {
  template = <<EOF
[
  {
    "name": "$${app_name}",
    "image": "$${webapp_docker_image}",
    "cpu": $${app_cpu},
    "memory": $${app_memory},
    "essential": true, 
    "portMappings": [
      {
        "containerPort": $${app_port},
        "hostPort": $${app_port}
      }
    ],
    "command": [],
    "entryPoint": [],
    "links": [],
    "mountPoints": [],
    "volumesFrom": [],
    "environment": []
  }
]
EOF

  vars = {
    webapp_docker_image = "${var.DOCKER_IMAGE_NAME}:${var.DOCKER_IMAGE_TAG}"
    app_name            = "${var.APP_NAME}"
    app_port            = var.APP_PORT
    app_cpu             = var.APP_CPU
    app_memory          = var.APP_MEMORY
  }
}
