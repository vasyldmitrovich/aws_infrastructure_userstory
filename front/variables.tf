variable "key-name" {
  default = "deployer-key"
}

variable "instance_role" {
  #  default = "RoleForEC2"
  default = "arn:aws:iam::975050096321:instance-profile/RoleForEC2"
}

variable "instance_ami" {
  default = "ami-0c1c30571d2dae5c9"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "sg_for_ec2_id" {
  description = "Security group for load balancer"
  type        = string
}

variable "pub_sub1_id" {
  description = "Public subnet 1"
  type        = string
}

variable "bucket_for_ec2" {
  description = "Bucket with data to ec2 template"
  type        = string
}

variable "alb_tg_arn" {
  description = "Load balancer target group arn"
  type        = string
}

variable "priv_sub1a_id" {
  description = "Private subnet 1a"
  type        = string
}

