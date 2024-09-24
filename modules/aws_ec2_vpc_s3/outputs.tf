output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "instance_id" {
  description = "IDs of EC2 instances"
  value = {
    for key, ec2 in module.ec2_instances : key => ec2.id
  }
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value = {
    for key, ec2 in module.ec2_instances : key => ec2.public_ip
  }
}

output "website_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.website_s3_bucket.arn
}

output "website_bucket_name" {
  description = "Name (id) of the S3 bucket"
  value       = module.website_s3_bucket.name
}

output "website_bucket_doamin" {
  description = "Domain name of the S3 bucket"
  value       = module.website_s3_bucket.domain
}

output "website_bucket_endpoint" {
  description = "Endpoint of the S3 bucket"
  value       = module.website_s3_bucket.endpoint
}
