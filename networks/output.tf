output "user_story_vpc_id" {
  description = "User story vpc"
  value = aws_vpc.user_story_main_vpc.id
}

output "user_story_pub_sub1_id" {
  description = "Public subnet for load balancer"
  value = aws_subnet.user_story_pub_subnet_1.id
}

output "user_story_pub_sub1a_id" {
  description = "Public subnet"
  value = aws_subnet.user_story_pub_subnet_1a.id
}

output "user_story_private_sub1a_id" {
  description = "Private subnet for front"
  value = aws_subnet.user_story_private_subnet_1a.id
}

output "user_story_gateway_id" {
  description = "Private subnet for front"
  value = aws_internet_gateway.user_story_gw.id
}