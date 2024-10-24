####### --------------------SG variables ----------------------- #######

output "VPC_ID" {
  value = aws_vpc.VPC.id
}

/* Public Subnets IDs */
output "PUBLIC_SUBNET_IDS" {
  value = join(",", aws_subnet.PUBLIC_SUBNET.*.id)
}

/* Private Application Subnets IDs */
output "PRIVATE_BACKEND_NAT_GAT_SUBNET_IDS" {
  value = join(",", aws_subnet.PRIVATE_BACKEND_NAT_GAT_SUBNET.*.id)
}

/* Private Database Subnets IDs */
output "PRIVATE_BACKEND_SUBNET_IDS" {
  value = join(",", aws_subnet.PRIVATE_BACKEND_SUBNET.*.id)
}