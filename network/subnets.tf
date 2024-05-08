
# Create public subnets (one per AZ)
resource "aws_subnet" "public_AZ1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_AZ1"
  }
}

resource "aws_subnet" "public_AZ2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_cidr2
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_AZ2"
  }
}

# Create private subnets (one per AZ)
resource "aws_subnet" "private_AZ1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "private_subnet_AZ1"
  }
}

resource "aws_subnet" "private_AZ2" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_cidr2
  availability_zone = "${var.region}b"
  
  tags = {
    Name = "private_subnet_AZ2"
  }
}
