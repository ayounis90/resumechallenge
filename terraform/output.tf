#output "resume_website_url" {
#  value = aws_s3_bucket_website_configuration.resume_website_config.website_endpoint
#}

output "primary_domain_name_servers" {
  value = aws_route53_zone.primary.name_servers
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}
