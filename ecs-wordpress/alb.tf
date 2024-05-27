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

  tags = {
    Name = "${var.APP_NAME}-${var.ENV_PREFIX}-alb-sg"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# ALB
resource "aws_alb" "ALB" {
  name            = "${var.APP_NAME}-${var.ENV_PREFIX}-alb"
  subnets         = var.PUBLIC_SUBNETS_IDS
  security_groups = ["${aws_security_group.ALB_SG.id}"]

  tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
    is_an_AWS_FMS_WAFv2_protected_resource = "Count"
  }
}

# Alb target group
resource "aws_alb_target_group" "ALB_TARGET_GROUP" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-alb-tg"
  port        = var.CONTAINER_PORT
  protocol    = "HTTP"
  vpc_id      = "${var.VPC_ID}"
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200,302"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "3"
    port                = var.CONTAINER_PORT
  }

  depends_on = [aws_alb.ALB]
}

# Alb Http listener
resource "aws_alb_listener" "HTTP_LISTENER" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_alb.ALB]
}

resource "aws_alb_listener" "HTTPS_LISTENER" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.CERTIFICATE_ARN

  default_action {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP.id
    type             = "forward"
  }

    depends_on = [aws_alb.ALB]
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
