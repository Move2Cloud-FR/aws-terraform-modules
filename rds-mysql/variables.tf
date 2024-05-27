########################### VPC Config ###############################
variable "VPC_ID" {}
variable "SUBNETS_IDS" {}

########################### Project name #############################
variable "APP_NAME" {}
variable "ENV_PREFIX" {}

########################### RDS Config ###############################
variable "DATABASE_USER" {}
variable "DATABASE_PASSWORD" {}
variable "DATABASE_NAME" {}
variable "DATABASE_INSTANCE_CLASS" {}
variable "AUTHORISED_CIDR_BLOCKS" {}
