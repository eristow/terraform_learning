output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_bucket.bucket_name
}

output "bucket_details" {
  description = "Details of the S3 bucket"
  value       = module.s3_bucket.bucket_details
}

# output "instance_ids" {
#   description = "IDs of the EC2 instances"
#   value       = module.ec2_instances.instance_ids
# }

# output "instance_names" {
#   description = "Names of the EC2 instances"
#   value       = module.ec2_instances.instance_names
# }

# output "web_server_count" {
#   description = "Number of web server instances"
#   value       = length(module.ec2_instances.instance_ids)
# }

# output "vpc_id" {
#   description = "ID of project VPC"
#   value       = module.vpc.vpc_id
# }

# output "lb_url" {
#   description = "URL of load balancer"
#   value       = module.elb_instance.elb_url
# }

# output "db_username" {
#   description = "Database administrator username"
#   value       = aws_db_instance.db.username
#   sensitive   = true
# }

# output "db_password" {
#   description = "Database administrator password"
#   value       = aws_db_instance.db.password
#   sensitive   = true
# }
