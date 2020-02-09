# modules/admin-ec2-instance/vars.tf


variable env {
  description = "Environment"
  type        = string
}


variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}


variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "dev"
}


variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}


variable ssh_key {
  description = "SSH key pair"
  type        = string
  default     = "admin"
}


variable "my_own_ip_address" {
  description = "The IP address I connect from"
  type        = string
  default     = "0.0.0.0/0"
}
