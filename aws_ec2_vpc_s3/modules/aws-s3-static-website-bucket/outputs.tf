# Output variable definitions

output "arn" {
  description = "ARN of the S3 bucket."
  value       = aws_s3_bucket.web.arn
}

output "name" {
  description = "Name (id) of the S3 bucket."
  value       = aws_s3_bucket.web.id
}

output "domain" {
  description = "Domain name of the S3 bucket."
  value       = aws_s3_bucket_website_configuration.web.website_domain
}

output "endpoint" {
  description = "Endpoint of the S3 bucket."
  value       = aws_s3_bucket_website_configuration.web.website_endpoint
}
