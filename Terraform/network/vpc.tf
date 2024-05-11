# Create vpc
resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "vpc44"
  }
}
