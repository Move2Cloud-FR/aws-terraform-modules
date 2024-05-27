/* Create a VPC with public and private subnets */

resource "aws_vpc" "VPC" {
    cidr_block           = var.VPC_CIDR
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.APP_NAME}_${var.ENV_PREFIX}_VPC"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_internet_gateway" "INTERNET_GATEWAY" {
    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = "${var.APP_NAME}_${var.ENV_PREFIX}_Internet_Gateway"
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
        Name = "${var.APP_NAME}_${var.ENV_PREFIX}_main_route_table"
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



resource "aws_subnet" "PRIVATE_SUBNET" {
  count             = length(var.PRIVATE_SUBNET_CIDRS)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PRIVATE_SUBNET_CIDRS[count.index]
  availability_zone = "${var.AWS_REGION}${var.SUBNET_AZS[count.index]}"

  tags = {
      Name = "${var.APP_NAME}_${var.ENV_PREFIX}_Private_Subnet${count.index + 1}"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_subnet" "PUBLIC_SUBNET" {
  count                   = length(var.PUBLIC_SUBNET_CIDRS)
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.PUBLIC_SUBNET_CIDRS[count.index]
  availability_zone       = "${var.AWS_REGION}${var.SUBNET_AZS[count.index]}"
  map_public_ip_on_launch = true

  tags = {
      Name = "${var.APP_NAME}_${var.ENV_PREFIX}_Public_Subnet${count.index + 1}"
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
      Name = "${var.APP_NAME}_${var.ENV_PREFIX}_Public_Route_Table"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table_association" "PUBLIC_SUBNETS_ROUTE_TABLE" {
  count          = length(var.PUBLIC_SUBNET_CIDRS)
  subnet_id      = element(aws_subnet.PUBLIC_SUBNET.*.id, count.index)
  route_table_id = aws_route_table.PUBLIC_SUBNET_ROUTE_TABLE.id
}

// IF var.PRIVATE_SUBNET_CIDRS is empty, do not create the following ressources :
resource "aws_eip" "ELASTIC_IP" {
    count         = length(var.PRIVATE_SUBNET_CIDRS) > 0 ? 1 : 0
    domain        = "vpc"
    depends_on    = [aws_internet_gateway.INTERNET_GATEWAY]
}

resource "aws_nat_gateway" "NAT_GATEWAY" {
    count         = length(var.PRIVATE_SUBNET_CIDRS) > 0 ? 1 : 0
    subnet_id     = aws_subnet.PUBLIC_SUBNET[0].id
    allocation_id = aws_eip.ELASTIC_IP[0].id
    
    tags = {
        Name = "${var.APP_NAME}_${var.ENV_PREFIX}_Nat_Gateway"
        Application = "${var.APP_NAME}"
        Environment = "${var.ENV_PREFIX}"
    }
}

resource "aws_route_table" "PRIVATE_SUBNET_ROUTE_TABLE" {
  count     = length(var.PRIVATE_SUBNET_CIDRS) > 0 ? 1 : 0
  vpc_id    = aws_vpc.VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY[0].id
  }

  tags = {
      Name = "${var.APP_NAME}_${var.ENV_PREFIX}_Private_Route_Table"
      Application = "${var.APP_NAME}"
      Environment = "${var.ENV_PREFIX}"
  }
}

resource "aws_route_table_association" "PRIVATE_SUBNETS_ROUTE_TABLE" {
  count          = length(var.PRIVATE_SUBNET_CIDRS) > 0 ? length(var.PRIVATE_SUBNET_CIDRS) : 0
  subnet_id      = element(aws_subnet.PRIVATE_SUBNET.*.id, count.index)
  route_table_id = aws_route_table.PRIVATE_SUBNET_ROUTE_TABLE[0].id
}
