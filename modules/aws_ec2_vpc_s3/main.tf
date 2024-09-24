provider "aws" {
  profile = var.aws_profile
  region  = var.main_aws_region

  default_tags {
    tags = {
      hashicorp-learn = "module-use"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instances" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "5.7.0"
  for_each = var.server_set

  name = "my-ec2-cluster"

  # AMI for Ubuntu 24.04 LTS (HVM), SSD Volume Type in us-east-1
  ami                    = var.server_info[each.key][0]
  instance_type          = var.server_info[each.key][1]
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name        = format("%s_%s", var.instance_group_name, each.key)
    Terraform   = "true"
    Environment = "dev"
  }
}

module "website_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name = "evan-website-bucket-2024-09-21"

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    public-bucket = true
  }

  files = {
    terraform_managed = true
    www_path          = "${path.root}/www"
  }

  cors_rules = [
    {
      allowed_headers = ["*"],
      allowed_methods = ["PUT", "POST"],
      allowed_origins = ["https://test.example.com"],
      expose_headers  = ["ETag"],
      max_age_seconds = 3000
    },
    {
      allowed_methods = ["GET"],
      allowed_origins = ["*"]
    }
  ]
}
