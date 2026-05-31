resource "aws_route53_zone" "main" {
  name = "townhallus.com"

  tags = {
    Project = "townhallus"
  }
}