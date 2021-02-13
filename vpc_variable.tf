variable "private_subnet_id_1" {
  default = "subnet-c3de2ca5" 
}

variable "private_subnet_id_2" {
  default = "subnet-b41d13ef"
}

variable "region" {
  default = ""
}

variable "projectName" {
  default = ""

}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}

variable "sg_name" {
  default = "prod-web-servers"
}
