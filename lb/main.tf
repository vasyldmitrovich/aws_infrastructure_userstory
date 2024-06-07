resource "aws_lb" "user_story_lb" {
#  name               = "userstory-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_for_elb_id]
  subnets            = [var.pub_sub1_id, var.pub_sub1a_id]
  depends_on         = [null_resource.wait_for_gateway]
}

resource "aws_lb_target_group" "user_story_alb_tg" {
#  name     = "user_story-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "user_story_front_end" {
  load_balancer_arn = aws_lb.user_story_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_story_alb_tg.arn
  }
}

resource "null_resource" "wait_for_gateway" {
  triggers = {
    gateway_id = var.gw_id
  }
}