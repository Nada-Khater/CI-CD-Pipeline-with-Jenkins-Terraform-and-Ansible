resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_db_subnet_group" "my_rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [module.network.private_subnet_id, module.network.private_subnet_id2]

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "Terraform_rds" {
  allocated_storage     = 10
  db_name              = "myrds_db"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  username              = "Nada_admin"
  password              = random_password.rds_password.result
  parameter_group_name  = "default.mysql5.7"
  db_subnet_group_name  = aws_db_subnet_group.my_rds_subnet_group.name
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

# Saving rds password to be added in jenkins credentials
resource "local_file" "rds_password_file" {
  content  = aws_db_instance.Terraform_rds.password
  filename = "rds_pass.txt"
}