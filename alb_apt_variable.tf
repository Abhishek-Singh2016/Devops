variable "apt_alb_name" {
  default ="APT"
}

variable "custom_fqdn_alb" {
  default ="cs-dev2-dist.test.com"
}



resource "aws_route53_record" "apt" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.custom_fqdn_alb}"
  type    = "A"

  alias {
    name                   = "${aws_lb.apt.dns_name}"
    zone_id                = "${aws_lb.apt.zone_id}"
    evaluate_target_health = false
  }
}
