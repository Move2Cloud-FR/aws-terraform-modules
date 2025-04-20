data "template_file" "TEMPLATE_FILE" {
  template = <<EOF
[
  {
    "name": "$${app_name}",
    "image": "$${webapp_docker_image}",
    "cpu": $${fargate_cpu},
    "memory": $${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/$${env_prefix}/$${app_name}",
          "awslogs-region": "$${AWS_REGION}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": $${app_port},
        "hostPort": $${app_port}
      }
    ],
    % if env_variables_json != "[]" :
    "environment": $${env_variables_json},
    % endif
    % if secrets_json != "[]" :
    "secrets": $${secrets_json},
    % endif
  }
]
EOF

  vars = {
    webapp_docker_image = "${var.DOCKER_IMAGE_NAME}:${var.DOCKER_IMAGE_TAG}"
    app_name            = "${var.APP_NAME}"
    env_prefix          = "${var.ENV_PREFIX}"
    app_port            = var.HTTP_APP_PORT
    fargate_cpu         = var.FARGATE_CPU
    fargate_memory      = var.FARGATE_MEMORY
    AWS_REGION          = var.AWS_REGION
    env_variables_json = jsonencode(local.env_variables_list)
    secrets_json = jsonencode(local.secrets_list)
  }
}

resource "aws_ecs_task_definition" "ECS_TASK_DEFINITION" {
  family                   = "${var.APP_NAME}_${var.ENV_PREFIX}_def"
  container_definitions    = data.template_file.TEMPLATE_FILE.rendered
  execution_role_arn       = var.TASK_EXECUTION_ROLE_ARN
  task_role_arn            = var.TASK_ROLE_ARN 
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.FARGATE_CPU
  memory                   = var.FARGATE_MEMORY
}

# ===== Locals to format data =====
locals {
  env_variables_list = [
    for key, val in var.ENV_VARIABLES : {
      name  = key
      value = val
    }
  ]

  secrets_list = [
    for key, val in var.SECRETS : {
      name      = key
      valueFrom = val
    }
  ]
}