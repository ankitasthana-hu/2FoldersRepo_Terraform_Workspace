###• Created the infrastructure into a VPC with the CIDR block 10.10.0.0/21 and create at
##least 2 private and 2 public subnets

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

##Use Frankfurt region
variable "region" {
  default     = "us-west-2"
}

variable "ssh_port" {
  default = 22
}

variable "nfs_port" {
  default = 2049
}

##The wordpress site should be reachable only on HTTP port
variable "http_port" {
  default = 80
}

/*
variable "credentials_file" {
  description = "The AWS configure credentials file"
  default = C:\Users\anasthan\project\wp_project\bv_terraform_workspace\Infrastructure_SetUp\.aws\credentials
}

variable "aws_profile" {
  description = "The AWS configure profile"
  default = ankit_cred
}
*/
