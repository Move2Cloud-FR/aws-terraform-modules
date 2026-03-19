# VPC Terraform Module

## Description
Creates a Virtual Private Cloud (VPC) with subnets and routing.

## Resources
- aws_vpc
- aws_subnet
- aws_route_table

## Inputs
Defined in `_variables.tf`:
- cidr_block
- subnet configuration
- tags

## Outputs
Defined in `_output.tf`:
- vpc_id
- subnet_ids

## Usage
module "vpc" {
  source = "...//vpc"
}