# Create public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.Igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Create private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  # Add a route to the NAT Gateway for internet access
  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.Nat-gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Associate public subnets to public route table
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_AZ1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_AZ2.id
  route_table_id = aws_route_table.public-rt.id
}

# Associate private subnets to  private route table
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_AZ1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_AZ2.id
  route_table_id = aws_route_table.private-rt.id
}