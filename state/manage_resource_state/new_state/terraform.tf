terraform {
  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_state_new.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
  }

  required_version = "~> 1.7"
}
