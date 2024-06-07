output "user_story_sg_for_elb_id" {
  description = "User story vpc"
  value = aws_security_group.user_story_sg_for_elb.id
}

output "user_story_sg_for_ec2_id" {
  description = "User story vpc"
  value = aws_security_group.user_story_sg_for_ec2.id
}