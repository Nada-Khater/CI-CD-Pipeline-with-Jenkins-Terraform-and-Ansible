module "network" {
  source               = "./network"
  region               = var.region
  cidr_block           = var.cidr_block
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  public_subnet_cidr2  = var.public_subnet_cidr2
  private_subnet_cidr  = var.private_subnet_cidr
  private_subnet_cidr2 = var.private_subnet_cidr2
}
