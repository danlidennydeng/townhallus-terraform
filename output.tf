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