variable "private_key_path" {
  default = "C:\\Private_Key_Pair\bv_europe_key.pem"   
}

variable "key_name" { 
  default = "bv_europe_key"  
}

variable "region" {
  description = "Region"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "free tier instance type"
  default     = "t2.small"
}

variable "volume_size" {
  description = "volume size for EBS"
  default     = 8
}

variable "ssh_port" {
  default = 22
}

variable "nfs_port" {
  default = 2049
}

variable "http_port" {
  default = 80
}