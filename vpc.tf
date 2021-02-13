data "aws_subnet" "subnet-selected1" {
  id = var.private_subnet_id_1
}



data  "aws_subnet" "subnet-selected2" {
  id = var.private_subnet_id_2
}

data "aws_vpc" "getVPC" {
  id = "vpc-531d1e34"
}
resource "aws_eip" "createNATGateway" {
  vpc      = true
  #depends_on = ["aws_vpc" "getVPC"aws_internet_gateway.createInternetGateway"]
  tags = "${merge(
    map(
      "Name", "Rd_Abhishek_Elastic_NAT",
       "product", "Rd_Abhishek_Elastic_NAT",
    )
  )}"
}

resource "aws_nat_gateway" "associateNATGateway" {
    allocation_id = "${aws_eip.createNATGateway.id}"
    subnet_id = "${data.aws_subnet.subnet-selected2.id}"
    #depends_on = ["aws_internet_gateway.createInternetGateway"]
  tags = "${merge(
    map(
      "Name", "Rd_Abhishek_NAT_Gateway",
      "product", "Rd_Abhishek_NAT_Gateway",

    )
  )}"
}

resource "aws_route_table" "createPrivateRouteTable" {
    vpc_id = "${data.aws_vpc.getVPC.id}"
  tags = "${merge(
    map(
      "Name", "Rd_Abhishek_Private_Route_Table",
      "product", "Rd_Abhishek_Private_Route_Table",
    )
  )}"
}

resource "aws_route" "associatePrivate_Route" {
	route_table_id  = "${aws_route_table.createPrivateRouteTable.id}"
	destination_cidr_block = "${var.destinationCIDRblock}"
	nat_gateway_id = "${aws_nat_gateway.associateNATGateway.id}"
}

resource "aws_route_table_association" "associatePriavteSubnet2" {
    subnet_id = "${data.aws_subnet.subnet-selected1.id}"
    route_table_id = "${aws_route_table.createPrivateRouteTable.id}"
}

