terraform {
  backend "s3" {
    bucket         = "terraform-nada"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "state-lock-nada"
  }
}
