terraform {
  backend "remote" {
    organization = "eristow-org"
    workspaces {
      name = "example_workspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  # profile = var.aws_profile
  region = var.main_aws_region
}

resource "aws_instance" "app_server" {
  # AMI for Ubuntu 24.04 LTS (HVM), SSD Volume Type in us-east-1
  # ami           = "ami-0e86e20dae9224db8"
  # Temp change to Ubuntu 22.04
  ami           = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
