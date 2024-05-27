resource "aws_alb" "ALB" {
  name            = "${var.APP_NAME}-${var.ENV_PREFIX}-ALB"
  # subnets         = split(",", var.SUBNETS_IDS)
  subnets         = var.SUBNETS_IDS
  security_groups = ["${aws_security_group.SG_ALB.id}"]
  idle_timeout    = 400
  # if the inactivity of the session between the client and server surpass 400 s the session is no longer maintained.

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# For blue/green deployment we create 2 target groups
resource "aws_alb_target_group" "ALB_TARGET_GROUP1" {
  name                  = "${var.APP_NAME}-${var.ENV_PREFIX}-TG1"
  port                  = var.APP_PORT
  protocol              = "HTTP"
  vpc_id                = "${var.VPC_ID}"
  deregistration_delay  = 300

  health_check {
    interval            = "30"
    path                = var.HEALTH_CHECK_PATH
    port                = var.APP_PORT
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }

  depends_on = [aws_alb.ALB]
}

resource "aws_alb_target_group" "ALB_TARGET_GROUP2" {
  name     = "${var.APP_NAME}-${var.ENV_PREFIX}-TG2"
  port     = var.APP_PORT
  protocol = "HTTP"
  vpc_id   = "${var.VPC_ID}"
  deregistration_delay = 300

  health_check {
    interval            = "30"
    path                = var.HEALTH_CHECK_PATH
    port                = var.APP_PORT
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }

  depends_on = [aws_alb.ALB]
}

resource "aws_alb_listener" "ALB_LISTENER" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = var.APP_PORT
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP1.id
    type             = "forward"
  }

  depends_on = [aws_alb.ALB]
}

resource "aws_alb_listener_rule" "ALB_LISTENER_RULE" {
  depends_on   = [aws_alb_target_group.ALB_TARGET_GROUP1]
  listener_arn = aws_alb_listener.ALB_LISTENER.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP1.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
