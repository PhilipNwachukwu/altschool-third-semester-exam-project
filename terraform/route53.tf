# Route53 Hosted Zone
resource "aws_route53_zone" "apache" {
  name = "philipnwachukwu.ml"
}

# Route53 Records
resource "aws_route53_record" "ns" {
  allow_overwrite = true
  name            = "philipnwachukwu.ml"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.apache.zone_id

  records = [
    aws_route53_zone.apache.name_servers[0],
    aws_route53_zone.apache.name_servers[1],
    aws_route53_zone.apache.name_servers[2],
    aws_route53_zone.apache.name_servers[3],
  ]
}
