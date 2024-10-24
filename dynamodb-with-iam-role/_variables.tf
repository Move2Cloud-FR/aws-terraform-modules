########################### DynamoDB Table ###############################
variable "DB_TABLE_NAME" {}
variable "IAM_ROLE_ARN" {}
variable "AWS_REGION" {}
variable "AUTOSCALE_READ_TARGET" {}
variable "AUTOSCALE_MIN_READ_CAPACITY" {}
variable "AUTOSCALE_MAX_READ_CAPACITY" {}
variable "AUTOSCALE_WRITE_TARGET" {}
variable "AUTOSCALE_MIN_WRITE_CAPACITY" {}
variable "AUTOSCALE_MAX_WRITE_CAPACITY" {}
