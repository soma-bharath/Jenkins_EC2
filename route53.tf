resource "aws_route53_record" "jenkins_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "dev.nn"  # Update with your desired domain name
  type    = "A"
  ttl     = "300"

  alias {
    name                   = aws_lb.Jenkins_Alb.dns_name
    zone_id                = data.aws_route53_zone.hosted_zone.zone_id
    evaluate_target_health = false
  }
depends_on=[aws_route53_zone.jenkins_zone]
}
