#----networking/main.tf

data "aws_availability_zones" "available" {}

resource "aws_vpc" "tz_dev_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "tz_dev_vpc"
  }
}

resource "aws_internet_gateway" "tz_dev_internet_gateway" {
  vpc_id = "${aws_vpc.tz_dev_vpc.id}"

  tags {
    Name = "tz_dev_igw"
  }
}

resource "aws_route_table" "tz_dev_public_rt" {
  vpc_id = "${aws_vpc.tz_dev_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tz_dev_internet_gateway.id}"
  }

  tags {
    Name = "tz_public"
  }
}

resource "aws_default_route_table" "tz_dev_private_rt" {
  default_route_table_id = "${aws_vpc.tz_dev_vpc.default_route_table.id}"

  tags {
    Name = "tz_private"
  }
}

resource "aws_subnet" "tz_dev_public_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.tz_dev_vpc.id}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "tz_dev_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "tz_dev_public_assoc" {
  count          = "${aws_subnet.tz_dev_public_subnet.count}"
  subnet_id      = "${aws_subnet.tz_dev_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tz_dev_public_rt.id}"
}

resource "aws_security_group" "tz_dev_public_sg" {
  name        = "tz_dev_public_sg"
  description = "Used to access public instances"
  vpc_id      = "${aws_vpc.tz_dev_vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTPS

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}