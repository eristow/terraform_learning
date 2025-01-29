module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)

  enable_nat_gateway = true
  enable_vpn_gateway = var.enable_vpn_gateway

  map_public_ip_on_launch = false

  tags = var.resource_tags
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "5.1.2"

  name        = "web-sg-${local.project_tag}"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks

  tags = var.resource_tags
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "5.1.2"

  name        = "lb-sg-${local.project_tag}"
  description = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.resource_tags
}

resource "random_string" "lb_id" {
  length  = 3
  special = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "4.0.2"

  # Ensure load balancer name is unique
  name = "lb-${random_string.lb_id.result}-${local.project_tag}"

  internal = false

  security_groups = [module.lb_security_group.security_group_id]
  subnets         = module.vpc.public_subnets

  number_of_instances = length(module.ec2_instances.instance_ids)
  instances           = module.ec2_instances.instance_ids

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }

  tags = var.resource_tags
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.5.0"

  bucket = "bucket-${local.project_tag}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPrefered"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "objects" {
  count = 4

  acl          = "public-read"
  key          = "object-${local.project_tag}.txt"
  bucket       = module.s3_bucket.s3_bucket_id
  content      = "Example object #${count.index}"
  content_type = "text/plain"
}

module "ec2_instances" {
  source = "./modules/aws-instance"

  depends_on = [module.vpc, aws_s3_bucket.example]

  instance_count     = var.instances_per_subnet * length(module.vpc.private_subnets)
  instance_type      = var.ec2_instance_type
  subnet_ids         = module.vpc.private_subnets[*]
  security_group_ids = [module.app_security_group.security_group_id]

  tags = var.resource_tags
}

module "example_sqs_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.2.1"

  depends_on = [aws_s3_bucket.example, module.ec2_instances]
}

# resource "aws_db_subnet_group" "private" {
#   subnet_ids = module.vpc.private_subnets
# }

# resource "aws_db_instance" "database" {
#   allocated_storage = 5
#   engine            = "mysql"
#   engine_version    = "5.7"
#   instance_class    = "db.t3.micro"
#   username          = var.db_username
#   password          = var.db_password

#   db_subnet_group_name = aws_db_subnet_group.private.name

#   skip_final_snapshot = true

#   tags = var.resource_tags
# }
