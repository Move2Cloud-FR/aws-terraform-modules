variable "VPC_ID" {
  description = "ID of the VPC"
  type        = string
}

variable "PRIVATE_SUBNETS_IDS" {}

variable "ROUTE_TABLE_IDS" {}

variable "AWS_REGION" {
  description = "AWS region"
  type        = string
}

variable "APP_NAME" {
  description = "Project name"
  type        = string
}

variable "ENV_PREFIX" {
  description = "Environment prefix"
  type        = string
}