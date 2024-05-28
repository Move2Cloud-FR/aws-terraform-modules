########################### Project name #############################
variable "APP_NAME" {}
variable "ENV_PREFIX" {}

########################### VPC Config ###############################
variable "AWS_REGION" {}
variable "VPC_ID" {}
variable "PUBLIC_SUBNETS_IDS" {}
variable "PRIVATE_APP_SUBNETS_IDS" {}

######################### Adminer Config ###############################
variable "ADMINER_DEFAULT_SERVER" {
  description = "URL of default database server"
  default     = "db"
}

variable "ADMINER_DESIGN" {
  description = "specify Adminer theme, see https://adminer.org/en#extras for options"
  default     = ""
}

variable "ADMINER_PLUGINS" {
  description = "add Adminer plugins, see https://hub.docker.com/_/adminer/ for details"
  default     = ""
}

########################### ECS Service ##############################
variable "TASK_EXECUTION_ROLE_ARN" {}
variable "NB_REPLICAS" {}
variable "CONTAINER_NAME" {}
variable "CONTAINER_PORT" {}
variable "DOCKER_IMAGE_NAME" {}
variable "DOCKER_IMAGE_TAG" {}
variable "FARGATE_CPU" {}
variable "FARGATE_MEMORY" {}

##################### ROUTE 53 CONFIGURATION #########################
variable "CERTIFICATE_ARN" {}
variable "ZONE" {}
variable "RECORD" {}

###################### TAGS Keys and Values ##########################
variable "CUSTOMER_TAGS" {
  type        = map(string)
  description = "Map of tags keys and values."
  default = {
    terraform = "Managed by Terraform"
  }
}