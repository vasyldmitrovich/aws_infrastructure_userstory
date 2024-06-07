variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "sg_ports_for_internet" {
  type    = list(number)
  default = [80, 443] # 22 -> ssh, 80 -> http, 443 -> https
}