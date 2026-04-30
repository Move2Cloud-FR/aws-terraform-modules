resource "aws_ecs_cluster" "ECS_CLUSTER" {
  name = "${var.APP_NAME}-cluster"
  
  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}