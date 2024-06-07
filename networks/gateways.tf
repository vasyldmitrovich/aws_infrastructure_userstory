# Internet Gateway
resource "aws_internet_gateway" "user_story_gw" {
  vpc_id = aws_vpc.user_story_main_vpc.id
}

# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "user_story_rt_public" {
  vpc_id = aws_vpc.user_story_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.user_story_gw.id
  }
}

# associate the route table with public subnet 1
resource "aws_route_table_association" "user_story_rta1" {
  subnet_id      = aws_subnet.user_story_pub_subnet_1.id
  route_table_id = aws_route_table.user_story_rt_public.id
}
# associate the route table with public subnet 2
resource "aws_route_table_association" "user_story_rta2" {
  subnet_id      = aws_subnet.user_story_pub_subnet_1a.id
  route_table_id = aws_route_table.user_story_rt_public.id
}

# Elastic IP for NAT gateway
resource "aws_eip" "user_story_eip" {
  depends_on = [aws_internet_gateway.user_story_gw]
  domain = "vpc"
  tags = {
    Name = "user_story_EIP_for_NAT"
  }
}

# NAT gateway for private subnets
# (for the private subnet to access internet - eg. ec2 instances downloading software from internet)
resource "aws_nat_gateway" "user_story_nat_for_private_subnet" {
  allocation_id = aws_eip.user_story_eip.id
  subnet_id     = aws_subnet.user_story_private_subnet_1a.id # nat should be in public subnet

  tags = {
    Name = "User story NAT for private subnet"
  }

  depends_on = [aws_internet_gateway.user_story_gw]
}

# route table - connecting to NAT
resource "aws_route_table" "user_story_rt_private" {
  vpc_id = aws_vpc.user_story_main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.user_story_nat_for_private_subnet.id
  }
}

# associate the route table with private subnet
resource "aws_route_table_association" "user_story_rta3" {
  subnet_id      = aws_subnet.user_story_private_subnet_1a.id
  route_table_id = aws_route_table.user_story_rt_private.id
}