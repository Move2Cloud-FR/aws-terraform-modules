########################### Project name #############################
variable "APP_NAME" {}
variable "ENV_PREFIX" {}

######################## ROUTE 53 CONFIGURATION ############################
variable "AWS_REGION" {}
variable "RECORD" {}
variable "PUBLIC_ZONE" {
  description = "The name of the public Route 53 zone"
  type        = string
  default     = ""
}
variable "PRIVATE_ZONE" {
  description = "The name of the private Route 53 zone"
  type        = string
  default     = ""
}
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
variable "CERTIFICATE_ARN" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = ""
}
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
variable "ECS_AUTO_SCALE_ENABLED" {}
variable "ECS_AUTO_SCALE_SCHEDULE_IN" {}
variable "ECS_AUTO_SCALE_SCHEDULE_OUT" {}

########################## VPC CONFIGURATION ###############################
variable "VPC_ID" {}
variable "PRIVATE_SUBNETS_IDS" {
  description = "List of private subnet IDs for public ALB"
  type        = list(string)
  default     = []
}

variable "PUBLIC_SUBNETS_IDS" {
  description = "List of public subnet IDs for public ALB"
  type        = list(string)
  default     = []
}


########################## ALB CONFIGURATION ###############################
variable "INTERNAL_ALB" {
  description = "Set to true if you want to create an internal ALB"
  type        = bool
  default     = false
}



