variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "aws_login"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "db_name" {
  default = "projectdb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  sensitive = true
}

variable "my_ip" {
  description = "Your public IP for Bastion SSH"
}