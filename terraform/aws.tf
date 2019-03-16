provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}
}

# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.55.0"
  name    = "${var.project-name}-vpc"

  cidr                             = "${var.vpc_cidr}"
  azs                              = ["eu-west-1a"]
  # private_subnets                  = ["${var.private_subnet_cidr_1}", "${var.private_subnet_cidr_2}", "${var.private_subnet_cidr_3}"]
  public_subnets                   = ["${var.public_subnet_cidr_1}"] # "${var.public_subnet_cidr_2}", "${var.public_subnet_cidr_3}"]
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  # enable_nat_gateway               = true
  # single_nat_gateway               = true
  one_nat_gateway_per_az           = false

  tags = "${var.tags}"
}

# Security Groups
data "http" "caller_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${chomp(data.http.caller_ip.body)}/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = "${var.tags}"
}


# EC2
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "launch-config" {
  name_prefix                 = "${var.project-name}-lc-"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.allow_http_ssh.id}"]
  user_data                   = "${}"
  # associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "bar" {
  name                 = "${var.project-name}-asg"
  launch_configuration = "${aws_launch_configuration.launch-config.name}"
  vpc_zone_identifier  = ["${module.vpc.public_subnets}"]
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}
