resource "aws_security_group" "sg1" {

  name                   = "${var.sg_name}-sg"
  description            = "Allow inbound traffic as Per Resource/Requirement"
  vpc_id                 = data.aws_subnet.subnet-selected1.vpc_id
  revoke_rules_on_delete = "true"
  tags = merge(
    map(
      "Name", "sg-${var.projectName}-${lower(var.sg_name)}",
      "product", "sg-${var.projectName}-${lower(var.sg_name)}"
    )
  )

}

