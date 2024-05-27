#############################################################################################
########### Instance profile which will be used in the ASG launch configuration #############
#############################################################################################

resource "aws_iam_role" "ECS_INSTANCE_ROLE" {
  name               = "${var.APP_NAME}EcsInstanceRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ECS_INSTANCE_ROLE_POLICY" {
  name   = "${var.APP_NAME}EcsInstanceRolePolicy"
  role   = aws_iam_role.ECS_INSTANCE_ROLE.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecs:StartTask"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ECS_INSTANCE_PROFILE" {
  name = "${var.APP_NAME}EcsInstanceProfile"
  role = aws_iam_role.ECS_INSTANCE_ROLE.name
}


#############################################################################################
################################# IAM Role for ECS services #################################
#############################################################################################

resource "aws_iam_role" "ECS_SERVICE_ROLE" {
  name               = "${var.APP_NAME}EcsServiceRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ECS_SERVICE_ROLE_POLICY" {
  name   = "${var.APP_NAME}EcsServiceRolePolicy"
  role   = aws_iam_role.ECS_SERVICE_ROLE.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:RegisterTargets",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}