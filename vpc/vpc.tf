/* Create a VPC with public and private subnets */

resource "aws_vpc" "VPC" {
    cidr_block           = var.VPC_CIDR
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.APP_NAME}-${var.ENV_PREFIX}-vpc"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_internet_gateway" "INTERNET_GATEWAY" {
    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = "${var.APP_NAME}-${var.ENV_PREFIX}-internet-gateway"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_route_table" "MAIN_ROUTE_TABLE" {
    vpc_id = aws_vpc.VPC.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.INTERNET_GATEWAY.id
    }

    tags = {
        Name = "${var.APP_NAME}-${var.ENV_PREFIX}-main-route-table"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_main_route_table_association" "MAIN_ROUTE_TABLE_ASSOCIATION" {
    vpc_id         = aws_vpc.VPC.id
    route_table_id = aws_route_table.MAIN_ROUTE_TABLE.id
}

resource "aws_vpc_dhcp_options" "DNS_RESOLVER" {
    domain_name_servers = ["AmazonProvidedDNS"]

    tags = {
        Name = "${var.APP_NAME}_${var.ENV_PREFIX}"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_vpc_dhcp_options_association" "DHCP_OPTIONS_ASSOCIATION" {
    vpc_id          = aws_vpc.VPC.id
    dhcp_options_id = aws_vpc_dhcp_options.DNS_RESOLVER.id
}

/* Public subnets */
resource "aws_subnet" "PUBLIC_SUBNET" {
  count                   = length(var.PUBLIC_SUBNET_CIDRS)
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.PUBLIC_SUBNET_CIDRS[count.index]
  availability_zone       = "${var.AWS_REGION}${var.SUBNET_AZS[count.index]}"
  map_public_ip_on_launch = true

  tags = {
      Name = "public-subnet-${count.index + 1}"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table" "PUBLIC_SUBNET_ROUTE_TABLE" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.INTERNET_GATEWAY.id
  }

  tags = {
      Name = "${var.APP_NAME}-${var.ENV_PREFIX}-public-route-table"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table_association" "PUBLIC_SUBNETS_ROUTE_TABLE" {
  count          = length(var.PUBLIC_SUBNET_CIDRS)
  subnet_id      = element(aws_subnet.PUBLIC_SUBNET.*.id, count.index)
  route_table_id = aws_route_table.PUBLIC_SUBNET_ROUTE_TABLE.id
}

/* Private Application subnets - With Nat Gateway */
resource "aws_subnet" "PRIVATE_APP_SUBNET" {
  count             = length(var.PRIVATE_APP_SUBNET_CIDRS)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PRIVATE_APP_SUBNET_CIDRS[count.index]
  availability_zone = "${var.AWS_REGION}${var.SUBNET_AZS[count.index]}"

  tags = {
      Name = "private-application-subnet-${count.index + 1}"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_eip" "ELASTIC_IP" {
    count         = length(var.PRIVATE_APP_SUBNET_CIDRS) > 0 ? 1 : 0
    domain        = "vpc"
    depends_on    = [aws_internet_gateway.INTERNET_GATEWAY]
}

resource "aws_nat_gateway" "NAT_GATEWAY" {
    count         = length(var.PRIVATE_APP_SUBNET_CIDRS) > 0 ? 1 : 0
    subnet_id     = aws_subnet.PUBLIC_SUBNET[0].id
    allocation_id = aws_eip.ELASTIC_IP[0].id
    
    tags = {
        Name = "${var.APP_NAME}-${var.ENV_PREFIX}-nat-gateway"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_route_table" "PRIVATE_APP_SUBNET_ROUTE_TABLE" {
  count     = length(var.PRIVATE_APP_SUBNET_CIDRS) > 0 ? 1 : 0
  vpc_id    = aws_vpc.VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY[0].id
  }

  tags = {
      Name = "${var.APP_NAME}-${var.ENV_PREFIX}-app-private-route-table"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table_association" "PRIVATE_APP_SUBNETS_ROUTE_TABLE" {
  count          = length(var.PRIVATE_APP_SUBNET_CIDRS) > 0 ? length(var.PRIVATE_APP_SUBNET_CIDRS) : 0
  subnet_id      = element(aws_subnet.PRIVATE_APP_SUBNET.*.id, count.index)
  route_table_id = aws_route_table.PRIVATE_APP_SUBNET_ROUTE_TABLE[0].id
}

/* Private Database subnets - Without Nat Gateway */

resource "aws_subnet" "PRIVATE_DB_SUBNET" {
  count             = length(var.PRIVATE_DB_SUBNET_CIDRS)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PRIVATE_DB_SUBNET_CIDRS[count.index]
  availability_zone = "${var.AWS_REGION}${var.SUBNET_AZS[count.index]}"

  tags = {
      Name = "private-database-subnet-${count.index + 1}"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table" "PRIVATE_DB_SUBNET_ROUTE_TABLE" {
  count     = length(var.PRIVATE_DB_SUBNET_CIDRS) > 0 ? 1 : 0
  vpc_id    = aws_vpc.VPC.id

  route {
    cidr_block     = var.VPC_CIDR
    gateway_id     = "local"
  }

  tags = {
      Name = "${var.APP_NAME}-${var.ENV_PREFIX}-db-private-route-table"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table_association" "PRIVATE_DB_SUBNETS_ROUTE_TABLE" {
  count          = length(var.PRIVATE_DB_SUBNET_CIDRS) > 0 ? length(var.PRIVATE_DB_SUBNET_CIDRS) : 0
  subnet_id      = element(aws_subnet.PRIVATE_DB_SUBNET.*.id, count.index)
  route_table_id = aws_route_table.PRIVATE_DB_SUBNET_ROUTE_TABLE[0].id
}