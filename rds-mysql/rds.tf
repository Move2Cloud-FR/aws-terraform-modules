# Security group for RDS
resource "aws_security_group" "RDS_SG" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-rds-sg"
  vpc_id      = "${var.VPC_ID}"
  description = "RDS ${var.APP_NAME}-${var.ENV_PREFIX}-service security group"
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = var.AUTHORISED_CIDR_BLOCKS
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV_PREFIX}-rds-sg"
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }
}

# Create RDS Subnet group
resource "aws_db_subnet_group" "RDS_SUBNET_GROUP" {
  subnet_ids = var.SUBNETS_IDS
}

# Create RDS instance
resource "aws_db_instance" "RDS_DB" {
  identifier                = "${var.APP_NAME}-${var.ENV_PREFIX}-db"
  allocated_storage         = 10
  engine                    = "mysql"
  instance_class            = var.DATABASE_INSTANCE_CLASS
  db_subnet_group_name      = aws_db_subnet_group.RDS_SUBNET_GROUP.id
  vpc_security_group_ids    = ["${aws_security_group.RDS_SG.id}"]
  db_name                   = var.DATABASE_NAME
  username                  = var.DATABASE_USER
  password                  = var.DATABASE_PASSWORD
  skip_final_snapshot       = true

 # make sure rds manual password chnages is ignored
  lifecycle {
     ignore_changes = [password]
   }
}