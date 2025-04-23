resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id           = var.VPC_ID
  service_name     = "com.amazonaws.${var.AWS_REGION}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids  = var.ROUTE_TABLE_IDS

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-dynamodb-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids   = var.PRIVATE_SUBNETS_IDS
  private_dns_enabled = true
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-ecr-api-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids   = var.PRIVATE_SUBNETS_IDS
  private_dns_enabled = true
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-ecr-dkr-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.logs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids   = var.PRIVATE_SUBNETS_IDS
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-cloudwatch-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.ROUTE_TABLE_IDS

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-s3-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.APP_NAME}-${var.ENV_PREFIX}-vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.VPC_ID

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ou référencez le SG des tâches ECS
  }

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-vpc-endpoint-sg"
    Environment = var.ENV_PREFIX
  }
}