
//step 7
//email-dns.tf one by one

# resource "aws_route53_record" "zoho_verification" {
#   zone_id = aws_route53_zone.main.zone_id

#   name = "townhallus.com"
#   type = "TXT"
#   ttl  = 300

#   records = [
#     "zoho-verification=zb53550424.zmverify.zoho.com"
#   ]
# }

resource "aws_route53_record" "zoho_mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "townhallus.com"
  type    = "MX"
  ttl     = 300

  records = [
    "10 mx.zoho.com",
    "20 mx2.zoho.com",
    "50 mx3.zoho.com"
  ]
}

resource "aws_route53_record" "root_txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "townhallus.com"
  type    = "TXT"
  ttl     = 300

  allow_overwrite = true

  records = [
    "zoho-verification=zb53550424.zmverify.zoho.com",
    "v=spf1 include:zohomail.com ~all"
  ]
}

resource "aws_route53_record" "zoho_dkim" {
  zone_id = aws_route53_zone.main.zone_id

  name = "townhallus._domainkey"
  type = "TXT"
  ttl  = 300

  records = [
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFZlxI/T4YGkYaXBUQfBUJmjid+Pd4LuneIwSxdZyoihxzZgV9nGIMRrmwuTFHfam9oClmdimmaKmg11b4i+bIolbaKhs/ArhXEAgOeG95+m0gaQ//fsJpW+PDElyLqHbK7uAnqOUwSk5jpaQjIuDptd7py3ojWuOs1LYssDNpPwIDAQAB"
  ]
}

resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DMARC1; p=none; rua=mailto:may01261946smith@gmail.com; ruf=mailto:may01261946smith@gmail.com; sp=none; adkim=r; aspf=r; pct=100"
  ]
}

//step 8 for sending transactional emails with mailtrap

resource "aws_route53_record" "mailtrap_verification" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "mt23.townhallus.com"
  type    = "CNAME"
  ttl     = 300

  records = ["smtp.mailtrap.live"]
}

resource "aws_route53_record" "mailtrap_dkim1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "rwmt1._domainkey.townhallus.com"
  type    = "CNAME"
  ttl     = 300

  records = ["rwmt1.dkim.smtp.mailtrap.live"]
}

resource "aws_route53_record" "mailtrap_dkim2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "rwmt2._domainkey.townhallus.com"
  type    = "CNAME"
  ttl     = 300

  records = ["rwmt2.dkim.smtp.mailtrap.live"]
}

resource "aws_route53_record" "mailtrap_tracking" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "mt-link.townhallus.com"
  type    = "CNAME"
  ttl     = 300

  records = ["t.mailtrap.live"]
}

//I did above after S3