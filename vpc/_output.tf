####### --------------------SG variables ----------------------- #######

output "VPC_ID" {
  value = aws_vpc.VPC.id
}

/* Public Subnets IDs */
output "PUBLIC_SUBNET_IDS" {
  value = join(",", aws_subnet.PUBLIC_SUBNET.*.id)
}

/* Private Application Subnets IDs */
output "PRIVATE_APP_SUBNET_IDS" {
  value = join(",", aws_subnet.PRIVATE_APP_SUBNET.*.id)
}

/* Private Database Subnets IDs */
output "PRIVATE_DB_SUBNET_IDS" {
  value = join(",", aws_subnet.PRIVATE_DB_SUBNET.*.id)
}