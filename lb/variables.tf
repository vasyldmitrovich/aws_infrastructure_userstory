variable "sg_for_elb_id" {
}

variable "vpc_id" {
}

variable "gw_id" {
}

variable "public_subnets" {
}

variable "private_subnets" {
}

variable "backend_count" {
  description = "Number Of Backends For Auto Scaling Group"
  type        = number
  default     = 2
}