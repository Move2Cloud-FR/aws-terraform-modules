resource "aws_vpc_endpoint" "lambda" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.lambda"
  vpc_endpoint_type = "Interface"
  subnet_ids   = var.PRIVATE_SUBNETS_IDS
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-lambda-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids   = var.PRIVATE_SUBNETS_IDS
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
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-ecr-dkr-endpoint"
    Environment = var.ENV_PREFIX
  }
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id       = var.VPC_ID
  service_name = "com.amazonaws.${var.AWS_REGION}.monitoring"
  vpc_endpoint_type = "Interface"
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.APP_NAME}-${var.ENV_PREFIX}-vpc-endpoint-sg"
    Environment = var.ENV_PREFIX
  }
}