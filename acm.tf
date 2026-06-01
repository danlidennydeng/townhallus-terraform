//step 1, to request TLS certificates, townhallus.com and www.townhallus.com
provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "townhallus"
}

resource "aws_acm_certificate" "frontend" {
  provider          = aws.virginia
  domain_name       = "townhallus.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "www.townhallus.com"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = "townhallus"
  }
}

//step 2, to validate 2 certificates, corresponding step 2 in output.tf
resource "aws_route53_record" "frontend_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "frontend" {
  provider        = aws.virginia
  certificate_arn = aws_acm_certificate.frontend.arn

  validation_record_fqdns = [
    for record in aws_route53_record.frontend_cert_validation :
    record.fqdn
  ]
}