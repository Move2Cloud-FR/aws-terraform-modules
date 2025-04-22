/**
  * Security group for ECS service
  */
resource "aws_security_group" "ECS_SERVICE_SG" {
  name        = "${var.APP_NAME}_${var.ENV_PREFIX}_ECS"
  vpc_id      = "${var.VPC_ID}"
  description = "Security group for ECS service"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}_${var.ENV_PREFIX}_ECS_SERVICE_SG"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

/**
  * We will utilize ALB and allow web access only from ALB
  */
resource "aws_security_group" "ALB_SG" {
  name        = "${var.APP_NAME}_${var.ENV_PREFIX}_ALB"
  vpc_id      = "${var.VPC_ID}"
  description = "Security group for ALBs"

  ingress {
    from_port   = var.HTTP_APP_PORT
    to_port     = var.HTTP_APP_PORT
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.HTTPS_APP_PORT
    to_port     = var.HTTPS_APP_PORT
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}_${var.ENV_PREFIX}_ALB_SG"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ECS_TASKS_SG" {
  name        = "${var.APP_NAME}_${var.ENV_PREFIX}_TASK"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${var.VPC_ID}"

  ingress {
    protocol        = "TCP"
    from_port       = var.HTTP_APP_PORT
    to_port         = var.HTTP_APP_PORT
    security_groups = [aws_security_group.ALB_SG.id]
  }

  ingress {
    protocol        = "TCP"
    from_port       = var.HTTPS_APP_PORT
    to_port         = var.HTTPS_APP_PORT
    security_groups = [aws_security_group.ALB_SG.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}_${var.ENV_PREFIX}_ECS_TASK_SG"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}
