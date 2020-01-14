resource "aws_internet_gateway" "wp_gw" {
  vpc_id = "${aws_vpc.wordpress_vpc.id}"
}

resource "aws_subnet" "public_1" {
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  cidr_block        = "${var.public_cidr1}"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "public_2" {
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  cidr_block        = "${var.public_cidr2}"
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "private_1" {
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  cidr_block        = "${var.private_cidr1}"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "private_2" {
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  cidr_block        = "${var.private_cidr2}"
  availability_zone = "eu-central-1b"
}

resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  instance_tenancy     = "dedicated"
}

/*
######################### TRYING to User Function CIDRSUBNET###################
#Trying to generate private and public CIDR through fucntion command
/*
data "template_file" "public_cidrsubnet" {

  template = "$${cidrsubnet(var.vpc_cidr,8,1)}"

}
*/
##############################################################################