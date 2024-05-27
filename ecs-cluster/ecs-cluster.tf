resource "aws_ecs_cluster" "ECS_CLUSTER" {
  name = "${var.APP_NAME}_${var.ENV_PREFIX}_cluster"
}