variable "VPC_ID" {
  description = "ID of the VPC"
  type        = string
}

variable "PRIVATE_SUBNETS_IDS" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ROUTE_TABLE_IDS" {
  description = "List of route table IDs for Gateway endpoints"
  type        = list(string)
}

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