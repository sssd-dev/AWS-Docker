variable "count" {
    default = 1
  }
variable "region" {
  description = "AWS region for hosting our your network"
  default = "ap-southeast-1"
}
variable "key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default = "../keys/mykey.pub"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default = "mykey"
}
variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}