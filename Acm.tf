resource "aws_acm_certificate" "cert" {
  private_key      =  "${file("${path.module}/data/private_key.pem")}"
  certificate_body = "${file("${path.module}/data/cert.pem")}" 
  certificate_chain = "${file("${path.module}/data/cert_chain.pem")}"
}
