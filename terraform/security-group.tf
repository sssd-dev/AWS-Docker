# Define the security group for public subnet
resource "aws_security_group" "elb" {
  name = "vpc_web"
  description = "Allow incoming HTTP connections & SSH access"
  vpc_id      = "${aws_vpc.docker.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["142.167.174.55/32"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["142.167.174.55/32"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["142.167.174.55/32"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["142.167.174.55/32"]
  }

  vpc_id="${aws_vpc.docker.id}"

  tags {
    Name = "Web Server SG"
  }
}

resource "aws_security_group" "sgdb"{
  name = "sg_db"
  description = "Allow traffic from public subnet"
  vpc_id      = "${aws_vpc.docker.id}"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.docker.id}"

  tags {
    Name = "DB SG"
  }
}