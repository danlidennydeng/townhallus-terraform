//step 7

resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "townhallus.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.townhallus.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

#step 11
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.townhallus.com"
  type    = "CNAME"
  ttl     = 300

  records = [
    aws_elastic_beanstalk_environment.api.cname
  ]
}