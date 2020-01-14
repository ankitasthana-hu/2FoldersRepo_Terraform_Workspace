terraform {
  required_version = ">= 0.12"
}


provider "aws" {
  shared_credentials_file = "${var.credentials_file}"
  profile                 = "${var.aws_profile}"
 
 
}

