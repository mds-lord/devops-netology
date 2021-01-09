provider "aws" {
    region = "us-west-2"
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

resource "aws_instance" "netology_test" {
    ami = data.aws_ami.ubuntu_latest.id
    instance_type = "t2.micro"
    tags = { 
        Type     = "test_instance"
        Services = "none"
    }
    user_data = "string of arguments to instance"
    volume_tags = { 
        Type = "test_volume"
    }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
