resource "aws_lb" "apt" {
  name               = "lb-tf-${var.apt_alb_name}"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${data.aws_subnet.subnet-selected2.id}"]
  security_groups    = ["${aws_security_group.sg1.id}"]
  enable_deletion_protection = true
  tags = "${merge(local.common_tags,map("Name", "lb-tf-${var.apt_alb_name}"))}"

}

# Port 443

resource "aws_alb_listener" "apt_https" {
  load_balancer_arn = tostring("${aws_lb.apt.arn}")
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn = "${aws_acm_certificate.cert.arn}"


  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.apt_http.arn}"
  }
  depends_on = [aws_lb.apt]
}

resource "aws_lb_target_group" "apt_http" {
  name     = "Target-group-http${var.apt_alb_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_subnet.subnet-selected1.vpc_id}"
  target_type = "instance"
  tags = "${merge(local.common_tags,map("Name", "Target-group-http${var.apt_alb_name}"))}"
}

resource "aws_lb_target_group_attachment" "apt_http" {
  target_group_arn = "${aws_lb_target_group.apt_http.arn}"
  target_id        = "${element(aws_instance.asginments.*.id,1)}"
  port             = 80
}





