data "template_file" "TEMPLATE_FILE" {
  template = <<EOF
[
   {
      "name":"$${CONTAINER_NAME}",
      "image":"$${DOCKER_IMAGE_NAME}:$${DOCKER_IMAGE_TAG}",
      "portMappings":[
         {
            "containerPort": $${CONTAINER_PORT},
            "protocol": "tcp"
        }
      ],
      "environment":[
         {
            "name": "ADMINER_DEFAULT_SERVER",
            "value": "$${ADMINER_DEFAULT_SERVER}"
         },
         {   
            "name": "ADMINER_DESIGN",
            "value": "$${ADMINER_DESIGN}"
         },
         {   
            "name": "ADMINER_PLUGINS",
            "value": "$${ADMINER_PLUGINS}"
         } 
      ],
      "logConfiguration":{
         "logDriver":"awslogs",
         "options":{
            "awslogs-group": "/ecs/$${APP_NAME}/$${ENV_PREFIX}",
            "awslogs-region": "$${AWS_REGION}",
            "awslogs-stream-prefix": "ecs"
         }
      },
      "essential":true
   }
]
EOF
  vars = {
    CONTAINER_NAME                 = "${var.CONTAINER_NAME}"
    CONTAINER_PORT                 = var.CONTAINER_PORT
    DOCKER_IMAGE_NAME              = "${var.DOCKER_IMAGE_NAME}"
    DOCKER_IMAGE_TAG               = "${var.DOCKER_IMAGE_TAG}"
    ADMINER_DEFAULT_SERVER         = "${var.ADMINER_DEFAULT_SERVER}"
    ADMINER_DESIGN                 = "${var.ADMINER_DESIGN}"
    ADMINER_PLUGINS                = "${var.ADMINER_PLUGINS}"
    AWS_REGION                     = "${var.AWS_REGION}"
    APP_NAME                       = "${var.APP_NAME}"
    ENV_PREFIX                     = "${var.ENV_PREFIX}"
  }
}

resource "aws_ecs_task_definition" "ECS_TASK_DEFINITION" {
  family                   = "${var.APP_NAME}"
  execution_role_arn       = var.TASK_EXECUTION_ROLE_ARN
  container_definitions    = data.template_file.TEMPLATE_FILE.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.FARGATE_CPU
  memory                   = var.FARGATE_MEMORY
}