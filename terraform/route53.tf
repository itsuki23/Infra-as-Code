# ------------------------------
#  Route53
# ------------------------------

# host-zone 参照
data "aws_route53_zone" "host_zone" {
  name = "climb-match.work"
}

# host-zone 定義
resource "aws_route53_zone" "host_zone" {
  name = "climb-match.work"
}

# dns-record
resource "aws_route53_record" "domain" {
  name    = data.aws_route53_zone.host_zone.name
  zone_id = data.aws_route53_zone.host_zone.zone_id
  type    = "A"
  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
}
output "domain_name" {
  value = aws_route53_record.domain.name
}
# curl http://**** で確認
