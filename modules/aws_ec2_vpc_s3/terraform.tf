terraform {
  # backend "remote" {
  #   organization = "eristow-org"
  #   workspaces {
  #     name = "example_workspace"
  #   }
  # }

  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_aws_ec2_vpc_s3.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67.0"
    }
  }

  required_version = "~> 1.9.6"
}
