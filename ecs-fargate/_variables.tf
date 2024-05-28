########################### Project name #############################
variable "APP_NAME" {}
variable "ENV_PREFIX" {}

######################## ROUTE 53 CONFIGURATION ############################
variable "AWS_REGION" {}
variable "ZONE" {}
variable "RECORD" {}

########################## ECS CONFIGURATION ###############################
variable "ECS_CLUSTER" {}
variable "DOCKER_IMAGE_NAME" {}
variable "DOCKER_IMAGE_TAG" {}
variable "HTTP_APP_PORT" {}
variable "HTTPS_APP_PORT" {}
variable "NB_REPLICAS" {}
variable "FARGATE_CPU" {}
variable "FARGATE_MEMORY" {}
variable "TASK_EXECUTION_ROLE_ARN" {}
variable "CODE_DEPLOY_ROLE_ARN" {}
variable "HEALTH_CHECK_PATH" {}
variable "CERTIFICATE_ARN" {}

########################## VPC CONFIGURATION ###############################
variable "VPC_ID" {}
variable "SUBNETS_IDS" {}


