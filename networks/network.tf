# VPC
resource "aws_vpc" "user_story_main_vpc" {
  cidr_block = "10.0.0.0/23" # 512 IPs
  tags = {
    Name = "user_story_project-vpc"
  }
}

# Creating 1st public subnet
resource "aws_subnet" "user_story_pub_subnet_1" {
  vpc_id                  = aws_vpc.user_story_main_vpc.id
  cidr_block              = "10.0.0.0/27" #32 IPs
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "eu-west-1a"
}
# Creating 2nd public subnet
resource "aws_subnet" "user_story_pub_subnet_1a" {
  vpc_id                  = aws_vpc.user_story_main_vpc.id
  cidr_block              = "10.0.0.32/27" #32 IPs
  map_public_ip_on_launch = true           # public subnet
  availability_zone       = "eu-west-1b"
}
# Creating 1st private subnet
resource "aws_subnet" "user_story_private_subnet_1a" {
  vpc_id                  = aws_vpc.user_story_main_vpc.id
  cidr_block              = "10.0.1.0/27" #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "eu-west-1b"
}