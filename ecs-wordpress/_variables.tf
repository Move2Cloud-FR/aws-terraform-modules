########################### Project name #############################
variable "APP_NAME" {}
variable "ENV_PREFIX" {}

########################### VPC Config ###############################
variable "AWS_REGION" {}
variable "VPC_ID" {}
variable "PUBLIC_SUBNETS_IDS" {}
variable "PRIVATE_APP_SUBNETS_IDS" {}
variable "PRIVATE_DB_SUBNETS_IDS" {}

########################### RDS Config ###############################
variable "DATABASE_USER" {}
variable "DATABASE_PASSWORD" {}
variable "DATABASE_NAME" {}
variable "DATABASE_INSTANCE_CLASS" {}

########################### ECS Service ##############################
variable "TASK_EXECUTION_ROLE_ARN" {}
variable "CONTAINER_NAME" {}
variable "CONTAINER_PORT" {}
variable "NB_REPLICAS" {}
variable "FARGATE_CPU" {}
variable "FARGATE_MEMORY" {}
variable "CERTIFICATE_ARN" {}
variable "DOCKER_IMAGE_NAME" {}
variable "DOCKER_IMAGE_TAG" {}

##################### ROUTE 53 CONFIGURATION #########################
variable "ZONE" {}
variable "RECORD" {}

