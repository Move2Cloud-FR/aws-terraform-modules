 # Create random password
 resource "random_password" "master_password" {
  length  = 16
  special = false
}

# 
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.APP_NAME}/rdscredentials"
  recovery_window_in_days = 0
}

variable "secrets" {
  default = {
    db_name    = var.DATABASE_NAME
    username   = var.DATABASE_USER
    password   = random_password.master_password.result
    endpoint   = aws_db_instance.RDS_DB.endpoint
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode(var.secrets)
}