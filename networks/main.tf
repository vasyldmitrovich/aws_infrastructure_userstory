# VPC
resource "aws_vpc" "user_story_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "user_story_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "user_story_gw" {
  vpc_id = aws_vpc.user_story_vpc.id
  tags = {
    Name = "user_story_gw"
  }
}

# Public subnets
resource "aws_subnet" "user_story_public_subnet" {
  count                   = length(var.vpc_public_subnets)
  vpc_id                  = aws_vpc.user_story_vpc.id
  cidr_block              = var.vpc_public_subnets[count.index]
  availability_zone       = var.vpc_availability_zones[count.index]
  tags = {
    Name = "pub-sub${count.index}"
  }
}

# Route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "user_story_public_route_table" {
  vpc_id = aws_vpc.user_story_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.user_story_gw.id
  }
  tags = {
    Name = "pub-sub-route-table"
  }
}

# Associate the route table with public subnet
resource "aws_route_table_association" "user_story_public_rt_association" {
  count = length(aws_subnet.user_story_public_subnet)
  subnet_id      = aws_subnet.user_story_public_subnet[count.index].id
  route_table_id = aws_route_table.user_story_public_route_table.id
}

# Private subnets
resource "aws_subnet" "user_story_private_subnet" {
  count = length(var.vpc_private_subnets)
  vpc_id                  = aws_vpc.user_story_vpc.id
  cidr_block              = var.vpc_private_subnets[count.index]
  availability_zone       = var.vpc_availability_zones[count.index]
  tags = {
    Name = "priv-sub${count.index}"
  }
}

# Elastic IP for NAT gateway
resource "aws_eip" "user_story_nat_eip" {
  depends_on = [aws_internet_gateway.user_story_gw]
  domain = "vpc"
  tags = {
    Name = "eip-for-nat-gateway"
  }
}

# NAT gateway to provide Internet access for private subnet
resource "aws_nat_gateway" "user_story_nat_for_private_subnet" {
  allocation_id = aws_eip.user_story_nat_eip.id
  subnet_id     = aws_subnet.user_story_public_subnet[0].id
  depends_on = [aws_internet_gateway.user_story_gw]
  tags = {
    Name = "nat-for-private-subnet"
  }
}

# Route table for private subnet - connecting to NAT
resource "aws_route_table" "user_story_private_route_table" {
  vpc_id = aws_vpc.user_story_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.user_story_nat_for_private_subnet.id
  }
  tags = {
    Name = "priv-sub-rt"
  }
}

# Associate the route table with private subnet
resource "aws_route_table_association" "user_story_private_rt_association" {
  count = length(aws_subnet.user_story_private_subnet)
  subnet_id      = aws_subnet.user_story_private_subnet[count.index].id
  route_table_id = aws_route_table.user_story_private_route_table.id
}