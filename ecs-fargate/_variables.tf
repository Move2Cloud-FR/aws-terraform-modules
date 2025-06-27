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
  description = "Task definition Environment variables if needed"
  type        = map(string)
  default     = {}
}

variable "SECRETS" {
  description = "Task definition Secrets as key-value pairs if needed"
  type        = map(string)
  default     = {}
}

########################## ECS SCHEDULED AUTO SCALING ###############################
variable "ECS_AUTO_SCALE_ENABLED" {
  description = "Enable ECS auto scaling schedule"
  type        = bool
  default     = false
}

variable "ECS_AUTO_SCALE_SCHEDULE_IN" {
  description = "Schedule expression for scaling in (only required if ECS_AUTO_SCALE_ENABLED is true)"
  type        = string
  default     = null
}

variable "ECS_AUTO_SCALE_SCHEDULE_OUT" {
  description = "Schedule expression for scaling out (only required if ECS_AUTO_SCALE_ENABLED is true)"
  type        = string
  default     = null
}

########################## VPC CONFIGURATION ###############################
variable "VPC_ID" {}
variable "SUBNETS_IDS" {}



