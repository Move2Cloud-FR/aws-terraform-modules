data "aws_route53_zone" "ZONE" {
  name = var.INTERNAL_ALB ? var.PRIVATE_ZONE : var.PUBLIC_ZONE
}

resource "aws_route53_record" "RECORD" {
  zone_id = data.aws_route53_zone.ZONE.zone_id
  name    = var.RECORD
  type    = "A"

  alias {
    name                   = aws_alb.ALB.dns_name
    zone_id                = aws_alb.ALB.zone_id
    evaluate_target_health = true
  }
  depends_on = [aws_alb.ALB]
}