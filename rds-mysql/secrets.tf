 # Create random password
 resource "random_password" "master_password" {
  length  = 16
  special = false
}

# 
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.APP_NAME}-rds/password"
}

resource "aws_secretsmanager_secret_version" "rds-credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = random_password.master_password.result
}