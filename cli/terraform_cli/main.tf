provider "aws" {
  region = var.region
}

provider "random" {}

provider "time" {}

resource "random_pet" "instance" {
  length    = 3
  separator = "-"
  prefix    = "project"
}


# VPC setup
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(var.private_subnet_cidr_blocks, 0, 1)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, 1)

  enable_nat_gateway = true
  enable_vpn_gateway = false
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "5.2.0"

  name        = "web-server-sg"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

# module "lb_security_group" {
#   source  = "terraform-aws-modules/security-group/aws//modules/web"
#   version = "5.2.0"

#   name        = "lb-sg-project-alpha-dev"
#   description = "Security group for load balancer with HTTP ports open within VPC"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
# }


# ELB setup
# module "elb_instance" {
#   source = "./modules/aws-elb"

#   instance_ids       = module.ec2_instances.instance_ids
#   public_subnets     = module.vpc.public_subnets
#   security_group_ids = [module.lb_security_group.security_group_id]
# }


# EC2 setup
# removed block is used to remove from state but not destroy
# removed {
#   from = module.ec2_instances

#   lifecycle {
#     destroy = false
#   }
# }

# module "ec2_instances" {
#   source = "./modules/aws-ec2-instance"

#   instance_name_prefix = random_pet.instance.id
#   instance_count       = var.instances_per_subnet * length(module.vpc.private_subnets)
#   subnet_ids           = module.vpc.private_subnets[*]
#   security_group_ids   = [module.app_security_group.security_group_id]
# }


# S3 setup
# module "s3_bucket" {
#   source = "./modules/aws-s3-bucket"

#   bucket_name = "eristow-terraform-s3-bucket"
# }

# resource "aws_s3_object" "example" {
#   bucket = module.s3_bucket.bucket_name

#   key    = "README.md"
#   source = "./README.md"

#   etag = filemd5("./README.md")
# }


# RDS setup
# resource "aws_db_subnet_group" "private" {
#   subnet_ids = module.vpc.private_subnets
# }

# resource "aws_db_instance" "db" {
#   allocated_storage = 5
#   engine            = "mysql"
#   engine_version    = "5.7"
#   instance_class    = "db.t3.micro"
#   username          = var.db_username
#   password          = var.db_password

#   db_subnet_group_name = aws_db_subnet_group.private.name

#   skip_final_snapshot = true
# }

# Hello module setup
# module "hello" {
#   source  = "joatmon08/hello/random"
#   version = "6.0.0"

#   hellos = {
#     hello        = random_pet.instance.id
#     second_hello = "World"
#   }

#   some_key = var.secret_key
# }
