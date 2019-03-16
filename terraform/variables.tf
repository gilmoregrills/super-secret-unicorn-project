variable "project-name" {
    description = "the name of the project"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
}

variable "public_subnet_cidr_1" {
  description = "CIDR for the Public Subnet"
}

variable "aws_region" {
  description = "Region for the VPC"
  default     = "eu-west-1"
}

variable "tags" {
  description = "A map of tags to pass to every resource"
  type        = "map"
}

variable "key_name" {
    description = "A valid pem key from your AWS account"
}
