####### --------------------SG variables ----------------------- #######

output "VPC_ID" {
  value = aws_vpc.VPC.id
}

/* Public Subnets IDs */
output "PUBLIC_SUBNET_IDS" {
  value = join(",", aws_subnet.PUBLIC_SUBNET.*.id)
}

/* Private Subnets IDs */
output "PRIVATE_SUBNET_IDS" {
  value = join(",", aws_subnet.PRIVATE_SUBNET.*.id)
}