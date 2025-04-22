resource "aws_alb" "ALB" {
  name            = "${var.APP_NAME}-${var.ENV_PREFIX}-alb"
  subnets         = var.INTERNAL_ALB ? var.PRIVATE_SUBNETS_IDS : var.PUBLIC_SUBNETS_IDS
  internal        = var.INTERNAL_ALB ? true : false
  security_groups = ["${aws_security_group.ALB_SG.id}"]
  idle_timeout    = 400
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# ALB target groups
resource "aws_alb_target_group" "ALB_TARGET_GROUP" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-alb-tg"
  port        = var.HTTP_APP_PORT
  protocol    = "HTTP"
  vpc_id      = "${var.VPC_ID}"
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "3"
    path                = var.HEALTH_CHECK_PATH
  }

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }

  depends_on = [aws_alb.ALB]
}

resource "aws_alb_listener" "HTTP_LISTENER" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = var.HTTP_APP_PORT
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.HTTPS_APP_PORT
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_alb.ALB]
}

resource "aws_alb_listener" "HTTPS_LISTENER" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = var.HTTPS_APP_PORT
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.CERTIFICATE_ARN

  default_action {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP.id
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "ALB_LISTENER_RULE" {
  depends_on   = [aws_alb_target_group.ALB_TARGET_GROUP]
  listener_arn = aws_alb_listener.HTTPS_LISTENER.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
