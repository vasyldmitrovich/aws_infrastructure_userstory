variable "vpc_id" {
}

variable "user_story_ports_for_alb_sg" {
  type    = list(number)
  default = [80, 443] # 80 -> http, 443 -> https
}

variable "user_story_ports_for_ec2_sg" {
  type    = list(number)
  default = [80, 443, 8080, 22] # 22 -> ssh, 80 -> http, 443 -> https, 8080 -> application
}