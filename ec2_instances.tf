resource "aws_key_pair" "ec2key" {
  key_name = "Abhishek_RD_account_key_pair"
  public_key = "${file("${path.module}/data/ssh_host_rsa_key.pub")}"
}

resource "aws_instance" "asginments" {
  count = "${length(var.instances_name)}"
  ami =  "${var.ec2freetier}" 
  instance_type          = "r5.large"
  subnet_id = "${data.aws_subnet.subnet-selected1.id}"
  key_name ="${aws_key_pair.ec2key.key_name}"
  disable_api_termination = false
  vpc_security_group_ids=["${aws_security_group.sg1.id}"]
  tags = "${merge(
    map(
      "Name", "${lower(var.instances_name[count.index])}",
       "product", "${lower(var.instances_name[count.index])}"
    )
  )}"
  volume_tags ="${merge(
    map(
      "Name", "${lower(var.instances_name[count.index])}",
       "product", "${lower(var.instances_name[count.index])}"
    )
  )}"
  root_block_device  {
      volume_size="${var.volumneSizeforRoot}"
      delete_on_termination=true
      encrypted=true
      kms_key_id = "${var.kmskeyidforRoot}"
  }
}