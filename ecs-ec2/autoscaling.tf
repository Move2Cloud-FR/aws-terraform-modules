resource "aws_launch_configuration" "LAUNCH_CONFIGURATION" {
  instance_type               = var.INSTANCE_TYPE
  image_id                    = var.ECS_IMAGE_ID
  iam_instance_profile        = "${aws_iam_instance_profile.ECS_INSTANCE_PROFILE.arn}"
  user_data                   = data.template_file.AUTOSCALING_USER_DATA.rendered
  security_groups             = ["${aws_security_group.SG_INSTANCES.id}"]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "AUTOSCALING_GROUP" {
  name                      = "${var.APP_NAME}_${var.ENV_PREFIX}_ASG"
  max_size                  = var.MAX_INSTANCE_SIZE
  min_size                  = var.MIN_INSTANCE_SIZE
  desired_capacity          = var.DESIRED_CAPACITY
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.LAUNCH_CONFIGURATION.name
  # vpc_zone_identifier       = split(",", var.SUBNETS_IDS)
  vpc_zone_identifier       = var.SUBNETS_IDS

  tag {
    key                 = "Name"
    value               = "${var.APP_NAME}_${var.ENV_PREFIX}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "AUTOSCALING_USER_DATA" {
  template = <<EOF
#!/bin/bash
set -x
set -e

# Update instance
yum update -y

# Join ECS cluster
echo 'ECS_CLUSTER=$${ecs_cluster}' > /etc/ecs/ecs.config
start ecs

EOF

  vars = {
    ecs_cluster = "${aws_ecs_cluster.ECS_CLUSTER.name}"
  }
}
