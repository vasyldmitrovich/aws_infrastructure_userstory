resource "aws_lb" "user_story_lb" {
#  name               = "user_story_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_for_elb_id]
  subnets            = [var.public_subnets[0],var.public_subnets[1],var.public_subnets[2]]#hardcode temporary
  depends_on         = [null_resource.wait_for_gateway]
  tags = {
    Name = "user-story-lb"
  }
}

# Create Listener Rule For Application Load Balancer For App
resource "aws_lb_target_group" "user_story_alb_tgt_grp" {
  count = var.backend_count
  name     = "app${count.index + 1}-target-group-${random_string.alb_prefix.result}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Create Listener For Application Load Balancer For App
resource "aws_lb_listener" "user_story_aws_lb_listener" {
  load_balancer_arn = aws_lb.user_story_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_story_alb_tgt_grp[0].arn
  }
}

#Create a Random string FOR Target Group name
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "null_resource" "wait_for_gateway" {
  triggers = {
    gateway_id = var.gw_id
  }
}