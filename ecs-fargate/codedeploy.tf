############ CodeDeploy application
resource "aws_codedeploy_app" "APPLICATION" {
  compute_platform = "ECS"
  name             = "${var.APP_NAME}-${var.ENV_PREFIX}"
}

############ Blue Green Deployments with ECS
resource "aws_codedeploy_deployment_group" "DEPLOY_GROUP" {
  app_name               = "${aws_codedeploy_app.APPLICATION.name}"
  deployment_group_name  = "${var.APP_NAME}-${var.ENV_PREFIX}-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = var.CODE_DEPLOY_ROLE_ARN

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
	    termination_wait_time_in_minutes = 1
    }
  }

  ecs_service {
    cluster_name = var.ECS_CLUSTER
    service_name = "${aws_ecs_service.ECS_SERVICE.name}"
  }


  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_alb_listener.HTTPS_LISTENER.arn}"]
      }

      target_group {
        name = "${aws_alb_target_group.ALB_TARGET_GROUP1.name}"
      }

      target_group {
        name = "${aws_alb_target_group.ALB_TARGET_GROUP2.name}"
      }
    }
  } 
}