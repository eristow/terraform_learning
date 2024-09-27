terraform {
  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_cli.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }

  required_version = "~> 1.9.6"
}
