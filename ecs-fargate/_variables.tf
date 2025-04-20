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
variable "HEALTH_CHECK_PATH" {}
variable "CERTIFICATE_ARN" {}
variable "TASK_EXECUTION_ROLE_ARN" {}
variable "TASK_ROLE_ARN" {}

########################### ECS SERVICE CONFIGURATION ###############################
variable "ENV_VARIABLES" {
  description = "Environment variables to inject"
  type        = map(string)
  default     = {}
}

variable "SECRETS" {
  description = "Secrets as key-value pairs (name => ARN)"
  type        = map(string)
  default     = {}
}

########################## ECS SCHEDULED AUTO SCALING ###############################
variable "ECS_AUTO_SCALE_ENABLED" {}
variable "ECS_AUTO_SCALE_SCHEDULE_IN" {}
variable "ECS_AUTO_SCALE_SCHEDULE_OUT" {}

########################## VPC CONFIGURATION ###############################
variable "VPC_ID" {}
variable "SUBNETS_IDS" {}



