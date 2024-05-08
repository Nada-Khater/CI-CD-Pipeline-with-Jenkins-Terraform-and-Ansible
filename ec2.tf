# Data source for instance ami
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.machine_type
  key_name               = aws_key_pair.ssh_key.key_name
  # subnet_id              = aws_subnet.public_AZ1.id
  subnet_id              = module.network.public_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh_anywhere.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    echo '${tls_private_key.ssh_key.private_key_pem}' > /home/ubuntu/${var.ssh_key_name}.pem
    chmod 400 /home/ubuntu/${var.ssh_key_name}.pem
    chown ubuntu:ubuntu /home/ubuntu/${var.ssh_key_name}.pem
  EOF
  
  tags = {
    Name = "bastion" 
  }

  # Print the public IP of bastion host in the inventory file 
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }
}

# Application instance
resource "aws_instance" "application" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.machine_type
  key_name               = aws_key_pair.ssh_key.key_name
  # subnet_id              = aws_subnet.private_AZ1.id
  subnet_id              = module.network.private_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh_port_3000_vpc_cidr.id]

  tags = {
    Name = "application" 
  }
}
