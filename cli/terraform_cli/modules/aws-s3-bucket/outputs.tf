output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "bucket_details" {
  description = "Details of the S3 bucket"
  value = {
    arn    = aws_s3_bucket.example.arn,
    region = aws_s3_bucket.example.region,
    id     = aws_s3_bucket.example.id
  }
}
