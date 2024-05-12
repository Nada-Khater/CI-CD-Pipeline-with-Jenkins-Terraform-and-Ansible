# Create internet gateway
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "Igw"
  }
}

# Allocate an Elastic IP for NAT Gateway
resource "aws_eip" "nat-eip" {
  vpc = true
}

# Create a NAT Gateway in one of the public subnets
resource "aws_nat_gateway" "Nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_AZ1.id
  
  tags = {
    Name = "Terraform Nat-gw"
  }
}
