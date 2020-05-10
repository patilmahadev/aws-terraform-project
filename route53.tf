resource "aws_route53_zone" "remotex-route53-zone" {
  name = "remotex.io"

  vpc {
    vpc_id = aws_vpc.remotex-vpc.id
  }
}

resource "aws_route53_record" "remotex-elb-record" {
  name    = "web.remotex.io"
  zone_id = aws_route53_zone.remotex-route53-zone.id
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_elb.remotex-elb.dns_name
    zone_id                = aws_elb.remotex-elb.zone_id
  }
}