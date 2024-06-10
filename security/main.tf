# Security group for load balancer
resource "aws_security_group" "user_story_sg_for_elb" {
  name   = "user-story-sg-for-elb"
  vpc_id = var.vpc_id

  # Allow ports, get data from variable
  dynamic "ingress" {
    for_each = var.user_story_ports_for_alb_sg
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      description      = "Allow all request from anywhere"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_for_elb"
  }
}

# Security group for load balancer
resource "aws_security_group" "user_story_sg_for_ec2" {
  name   = "user-story-sg-for-ec2"
  vpc_id = var.vpc_id

  # Allow ports, get data from variable
  dynamic "ingress" {
    for_each = var.user_story_ports_for_ec2_sg
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      description      = "Allow all request from anywhere"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_for_ec2"
  }
}