provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "mds-netology-study-01"
    key            = "main-infra/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = false
  }
}

data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "amazon_linux" { 
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"] 
  }
  filter {
    name = "owner-alias"
    values = ["amazon"] 
  }
}

locals {
  ec2_instance_type_map = {
    stage = "t2.micro"
    prod = "t2.micro"
  }
  ec2_instance_count_map = {
    stage = 1
    prod = 2
  }
  instances = {
    "ubuntu"       = data.aws_ami.ubuntu_latest.id
    "amazon_linux" = data.aws_ami.amazon_linux.id
  }
}

resource "aws_instance" "netology_test" {
  ami = data.aws_ami.ubuntu_latest.id
  instance_type = local.ec2_instance_type_map[terraform.workspace]
  count = local.ec2_instance_count_map[terraform.workspace]
  tags = { 
    Type     = "test_instance"
    Services = "none"
  }
  user_data = "string of arguments to instance"
  volume_tags = { 
    Type = "test_volume"
  }
  lifecycle {
    create_before_destroy = true 
  }
}

resource "aws_instance" "netology_foreach" {
  for_each = local.instances
  ami = each.value
  instance_type = local.ec2_instance_type_map[terraform.workspace]
  tags = {
    Name = each.key
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
