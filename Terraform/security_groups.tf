# Define a security group to allow SSH access from anywhere
resource "aws_security_group" "allow_ssh_anywhere" {
  # vpc_id = aws_vpc.main-vpc.id
  vpc_id        = module.network.vpc_id

  # Define ingress (inbound) rules
  ingress {
    from_port   = var.ingress_TCP_port
    to_port     = var.ingress_TCP_port
    protocol    = var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  # Define egress (outbound) rules
  egress {
    from_port   = var.egress_TCP_port
    to_port     = var.egress_TCP_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.cidr_block]  # Allow all outbound traffic for bastion ec2
  }
}


# Define a security group to allow SSH on port 22 and access to port 3000 within the VPC
resource "aws_security_group" "allow_ssh_port_3000_vpc_cidr" {
  # vpc_id = aws_vpc.main-vpc.id
  vpc_id        = module.network.vpc_id

  # Define ingress (inbound) rules
  ingress {
    from_port   = var.ingress_TCP_port
    to_port     = var.ingress_TCP_port
    protocol    = var.ingress_protocol
    # cidr_blocks = [aws_vpc.main-vpc.cidr_block]
    cidr_blocks = [module.network.vpc_cidr]
  }

  ingress {
    from_port   = var.ingress_TCP_port2
    to_port     = var.ingress_TCP_port2
    protocol    = var.ingress_protocol
    # cidr_blocks = [aws_vpc.main-vpc.cidr_block]
    cidr_blocks = [module.network.vpc_cidr]
  }

  # Define egress (outbound) rules
  egress {
    from_port   = var.egress_TCP_port
    to_port     = var.egress_TCP_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.cidr_block]  # Allow all outbound traffic for application ec2
  }
}

# Define a security group for redis
resource "aws_security_group" "redis_sg" {
  name          = "redis-sg"
  vpc_id        = module.network.vpc_id

  ingress {
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = var.egress_TCP_port
    to_port     = var.egress_TCP_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.cidr_block]  # Allow all outbound traffic for redis
  }
}

# Define a security group for rds
resource "aws_security_group" "rds_sg" {
  name          = "rds-sg"
  vpc_id        = module.network.vpc_id

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = var.egress_TCP_port
    to_port     = var.egress_TCP_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.cidr_block]  # Allow all outbound traffic for rds
  }
}

# Define a security group for alb
resource "aws_security_group" "alb_sg" {
  vpc_id        = module.network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_alb"
  }
}