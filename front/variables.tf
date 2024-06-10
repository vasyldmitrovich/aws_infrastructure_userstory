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
}

variable "public_subnets_ids" {
}

variable "private_subnets_ids" {
}

variable "bucket_for_ec2" {
}

variable "alb_tgt_grp_arn" {
}

variable "backend_count" {
}