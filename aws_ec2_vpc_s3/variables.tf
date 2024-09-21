variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "main_aws_region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "example-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "instance_group_name" {
  description = "Values of the Name tag for the EC2 instance"
  type        = string
  default     = "Example"
}

variable "server_set" {
  description = "A map of server names to instance types"
  type        = set(string)
  default = [
    "app",
    "db"
  ]
}

variable "server_info" {
  description = "A map of server names to instance info"
  type        = map(list(string))
  default = {
    "app" = ["ami-0e86e20dae9224db8", "t2.micro"]
    "db"  = ["ami-0e86e20dae9224db8", "t2.micro"]
  }
}
