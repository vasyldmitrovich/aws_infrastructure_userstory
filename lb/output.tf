output "user_story_alb_tgt_grp_arn" {
  description = "Load balancer target group arn"
  value = aws_lb_target_group.user_story_alb_tgt_grp[0].arn
}

output "backend_count" {
  value = var.backend_count
}