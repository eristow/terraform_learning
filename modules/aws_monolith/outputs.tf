output "website_endpoint" {
  description = "The endpoint of the website"
  value       = "http://${aws_s3_bucket_website_configuration.bucket.website_endpoint}/index.html"
}
