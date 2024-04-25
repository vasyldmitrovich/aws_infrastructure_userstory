variable "instance_region" {
   default = "eu-west-1"
}

variable "instance_ami" {
   default = "ami-0c1c30571d2dae5c9"
}

variable "instance_type" {
   default = "t2.micro"
}

variable "AWS_ACCESS_KEY_ID" {
  default = "___"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  default = "___"
  type        = string
}

variable "key-name" {
  default = "deployer-key"
}

variable "instance_role" {
#  default = "RoleForEC2"
  default = "arn:aws:iam::975050096321:instance-profile/RoleForEC2"
}

variable "sg_ports_for_internet" {
  type    = list(number)
  default = [80, 443] # 22 -> ssh, 80 -> http, 443 -> https
}