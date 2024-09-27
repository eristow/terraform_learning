terraform {
  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_move.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }

  required_version = "~> 1.9.6"
}
