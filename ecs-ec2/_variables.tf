######################## IAM CONFIGURATION ############################
variable "TASK_POLICY_ARN" {}
variable "CODE_DEPLOY_ECS_ARN" {}
variable "TASK_EXECUTION_ROLE_ARN" {}
variable "CODE_DEPLOY_ROLE_ARN" {}

########################## ECS CONFIGURATION ###############################
variable "ENV_PREFIX" {}
variable "APP_NAME" {}
variable "APP_PORT" {}
variable "APP_CPU" {}
variable "APP_MEMORY" {}
variable "MIN_INSTANCE_SIZE" {}
variable "MAX_INSTANCE_SIZE" {}
variable "DESIRED_CAPACITY" {}
variable "MINIMUM_HEALTHY_PERCENT" {}
variable "HEALTH_CHECK_PATH" {}
variable "INSTANCE_TYPE" {}
variable "ECS_IMAGE_ID" {}
variable "DOCKER_IMAGE_NAME" {}
variable "DOCKER_IMAGE_TAG" {}

########################## VPC CONFIGURATION ###############################
variable "VPC_ID" {}
variable "SUBNETS_IDS" {}