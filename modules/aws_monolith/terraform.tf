terraform {
  # backend "remote" {
  #   organization = "eristow-org"
  #   workspaces {
  #     name = "example_workspace"
  #   }
  # }

  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_monolith.tfstate"
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

provider "aws" {
  # profile = var.aws_profile
  region = var.main_aws_region
}

resource "random_pet" "petname" {
  length    = 3
  separator = "-"
}

