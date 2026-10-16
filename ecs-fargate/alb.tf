resource "aws_alb" "ALB" {
  name            = "${var.APP_NAME}-alb"
  subnets         = var.SUBNETS_IDS
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
  name        = "${var.APP_NAME}-alb-tg"
  port        = var.HTTP_APP_PORT
  protocol    = "HTTP"
  vpc_id      = "${var.VPC_ID}"
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
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
  # After the redirect of the other host names (priority 1) when there are some.
  priority = length(var.REDIRECT_HOSTS) == 0 ? null : 100

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

# Plain HTTP on its usual port: to HTTPS, same host, path and query.
resource "aws_alb_listener" "HTTP_REDIRECT_LISTENER" {
  count             = var.HTTP_REDIRECT_PORT == null ? 0 : 1
  load_balancer_arn = aws_alb.ALB.arn
  port              = var.HTTP_REDIRECT_PORT
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.HTTPS_APP_PORT
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# The other host names of the service (www, older domains): to RECORD, path and query kept.
resource "aws_alb_listener_rule" "REDIRECT_HOSTS_RULE" {
  count        = length(var.REDIRECT_HOSTS) == 0 ? 0 : 1
  listener_arn = aws_alb_listener.HTTPS_LISTENER.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      host        = var.RECORD
      port        = var.HTTPS_APP_PORT
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = var.REDIRECT_HOSTS
    }
  }
}
