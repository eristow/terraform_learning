output "lb_security_group_ids" {
  description = "Security group IDs for load balancer"
  value       = [module.lb_security_group.security_group_id]
}

output "app_security_group_ids" {
  description = "Security group IDs for application servers"
  value       = [module.app_security_group.security_group_id]
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_dns_name" {
  description = "Public DNS names of the load balancer for this project"
  value       = module.elb_http.elb_dns_name
}

output "vpc_id" {
  description = "ID of project VPC"
  value       = module.vpc.vpc_id
}

output "lb_url" {
  description = "URL of load balancer"
  value       = "http://${module.elb_http.elb_dns_name}/"
}

output "web_instance_count" {
  description = "Number of EC2 instances provisioned"
  value       = length(module.ec2_instances.instance_ids)
}

output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

# output "db_username" {
#   description = "Username for database"
#   value       = var.db_username
#   sensitive   = true
# }

# output "db_password" {
#   description = "Password for database"
#   value       = var.db_password
#   sensitive   = true
# }
