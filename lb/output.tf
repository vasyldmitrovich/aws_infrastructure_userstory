output "user_story_alb_tg_arn" {
  description = "Load balancer target group arn"
  value = aws_lb_target_group.user_story_alb_tg.arn
}