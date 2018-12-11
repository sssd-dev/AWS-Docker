resource "aws_vpc" "docker" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "docker-vpc"
  }
}
# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.docker.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"

  tags {
    Name = "Web Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.docker.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"

  tags {
    Name = "Database Private Subnet"
  }
}
