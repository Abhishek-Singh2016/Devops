resource "aws_security_group_rule" "outboundRule1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = -1 
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg1.id
}

resource "aws_security_group_rule" "outboundRule2"{
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg1.id
}


