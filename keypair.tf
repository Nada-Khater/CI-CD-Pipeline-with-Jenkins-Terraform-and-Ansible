# Create an AWS key pair for SSH access
resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Generate private key
resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
  rsa_bits    = 2048
}

# Save private key to local file
resource "local_file" "private_key_file" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.ssh_key_name}.pem"
}

# # Display both private key and public key on cmd
# output "ssh_private_key" {
#   value     = tls_private_key.ssh_key.private_key_pem
#   sensitive = true      # hide it on cmd
# }

# output "ssh_public_key" {
#   value     = tls_private_key.ssh_key.public_key_openssh
# }
