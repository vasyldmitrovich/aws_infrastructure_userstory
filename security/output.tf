output "user_story_sg_for_elb_id" {
  description = "Security group id for load balancer"
  value = aws_security_group.user_story_sg_for_elb.id
}

output "user_story_sg_for_ec2_id" {
  description = "Security group id for ec2 instances"
  value = aws_security_group.user_story_sg_for_ec2.id
}