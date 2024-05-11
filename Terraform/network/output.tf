output vpc_id {
  value       = aws_vpc.main-vpc.id
  description = "VPC id"
}

output vpc_cidr {
  value       = aws_vpc.main-vpc.cidr_block
  description = "VPC cidr"
}

output public_subnet_id{
    value       = aws_subnet.public_AZ1.id
    description = "Public Subnet id"
}

output public_subnet_id2{
    value       = aws_subnet.public_AZ2.id
    description = "Public Subnet id 2"
}

output private_subnet_id{
    value       = aws_subnet.private_AZ1.id
    description = "Private Subnet id"
}

output private_subnet_id2{
    value       = aws_subnet.private_AZ2.id
    description = "Private Subnet id 2"
}