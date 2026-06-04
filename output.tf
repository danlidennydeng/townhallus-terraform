//step 1
output "route53_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  value = aws_route53_zone.main.name_servers
}

//Step 2
output "certificate_arn" {
  value = aws_acm_certificate.frontend.arn
}

//step 3

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend_www.bucket
}

output "frontend_bucket_arn" {
  value = aws_s3_bucket.frontend_www.arn
}

//step 5

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}