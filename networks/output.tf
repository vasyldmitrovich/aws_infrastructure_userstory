output "user_story_vpc_id" {
  description = "UserStory vpc id"
  value = aws_vpc.user_story_vpc.id
}

output "user_story_gw_id" {
  description = "UserStory gateway id"
  value = aws_internet_gateway.user_story_gw.id
}

output "vpc_public_subnets_ids" {
  description = "UserStory public subnet ids"
  value = aws_subnet.user_story_public_subnet.*.id
}

output "vpc_private_subnets_ids" {
  description = "UserStory private subnet ids"
  value = aws_subnet.user_story_private_subnet.*.id
}
