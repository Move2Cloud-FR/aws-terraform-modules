# ALB Security group
resource "aws_security_group" "ALB_SG" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-alb-sg"
  vpc_id      = "${var.VPC_ID}"
  description = "Security group for ALBs"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.local_tags, {Name = "${var.APP_NAME}-${var.ENV_PREFIX}-alb-sg"})
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
  tags = merge(local.local_tags, {Name = "${var.APP_NAME}-${var.ENV_PREFIX}-ecs-sg"})
}