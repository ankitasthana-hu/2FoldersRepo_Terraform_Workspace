variable "vpc_cidr" {
  description = "VPC cidr"
  default     = "10.10.0.0/21"
}

variable "public_cidr1" {
  description = "Public Subnet-1"
  default     = "10.10.0.0/24"
}

variable "public_cidr2" {
  description = "Public Subnet-2"
  default     = "10.10.1.0/24"
}

variable "private_cidr1" {
  description = "Private Subnet-1"
  default     = "10.10.2.0/24"
}

variable "private_cidr2" {
  description = "Private Subnet-2"
  default     = "10.10.3.0/24"
}