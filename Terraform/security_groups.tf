# Define a security group to allow SSH access from anywhere
resource "aws_security_group" "allow_ssh_anywhere" {
  # vpc_id = aws_vpc.main-vpc.id
  vpc_id = module.network.vpc_id

  # Define ingress (inbound) rules
  ingress {
    from_port   = var.ingress_TCP_port
    to_port     = var.ingress_TCP_port
    protocol    = var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  # Define egress (outbound) rules
  egress {
    from_port = var.egress_TCP_port
    to_port   = var.egress_TCP_port
    protocol  = var.egress_protocol
    cidr_blocks = [var.cidr_block]  # Allow all outbound traffic for bastion ec2
  }
}


# Define a security group to allow SSH on port 22 and access to port 3000 within the VPC
resource "aws_security_group" "allow_ssh_port_3000_vpc_cidr" {
  # vpc_id = aws_vpc.main-vpc.id
  vpc_id = module.network.vpc_id

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
}