// redirect non-naked domain to lb
resource "aws_route53_record" "dualstack_alias" {
  type    = "A"
  zone_id = "Z1023527RS6FKHEBV4ZZ"
  name    = "www.jenkins.biosapplication.com"

  alias {
    evaluate_target_health = false
    zone_id                = aws_lb.load_balancer.zone_id
    name                   = "dualstack.${aws_lb.load_balancer.dns_name}"
  }
}


// redirect naked domain to www
resource "aws_route53_record" "www_redirect" {
  type    = "A"
  zone_id = "Z1023527RS6FKHEBV4ZZ"
  name    = "jenkins.biosapplication.com"

  alias {
    evaluate_target_health = false
    zone_id                = aws_lb.load_balancer.zone_id
    name                   = "dualstack.${aws_lb.load_balancer.dns_name}"
  }
}