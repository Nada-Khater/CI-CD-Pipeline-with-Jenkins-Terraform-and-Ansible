variable region {
  type        = string
  description = "Region Name"
}

variable machine_type {
  type        = string
  description = "Instance Type"
}

variable cidr_block {
  type        = string
  description = "Cidr Block"
}

variable ssh_key_name {
  type        = string
  description = "SSH Key Name"
}

variable ingress_protocol {
  type        = string
  description = "Ingress Protocol"
}

variable egress_protocol {
  type        = string
  description = "Egress Protocol"
}

variable ingress_TCP_port {
  type        = number
  description = "Ingress TCP Port"
}

variable ingress_TCP_port2 {
  type        = number
  description = "Ingress TCP Port 2"
}

variable rds_port {
  type        = number
  description = "RDS Port"
}

variable redis_port {
  type        = number
  description = "REDIS Port"
}

variable egress_TCP_port {
  type        = number
  description = "Egress TCP Port"
}

variable vpc_cidr {
  type        = string
  description = "Vpc Cidr"
}

variable public_subnet_cidr {
  type        = string
  description = "Public Subnet Cidr"
}

variable public_subnet_cidr2 {
  type        = string
  description = "Public Subnet Cidr 2"
}

variable private_subnet_cidr {
  type        = string
  description = "Private Subnet Cidr"
}

variable private_subnet_cidr2 {
  type        = string
  description = "Private Subnet Cidr 2"
}
