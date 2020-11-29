#Create VPC
resource "aws_vpc" "VPC_LABO6" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "VPC_LABO6"
  }
}



#SUBNETS

# Create public subnet1
resource "aws_subnet" "LABO6_sub1" {
  vpc_id                  = aws_vpc.VPC_LABO6.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "LABO6_sub1"
  }
}

# Create public subnet2
resource "aws_subnet" "LABO6_sub2" {
  vpc_id                  = aws_vpc.VPC_LABO6.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "LABO6_sub2"
  }
}







#ROUTING TABLE

# Create aws_route_table
resource "aws_route_table" "LABO6-RoutingT" {
  vpc_id = aws_vpc.VPC_LABO6.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.LABO6-GW.id
  }
  tags = {
    Name = "LABO6-RoutingT"
  }
}

# Create aws_route_table_association 1
resource "aws_route_table_association" "Routing-a" {
  subnet_id      = aws_subnet.LABO6_sub1.id
  route_table_id = aws_route_table.LABO6-RoutingT.id
}

# Create aws_route_table_association 2
resource "aws_route_table_association" "Routing-b" {
  subnet_id      = aws_subnet.LABO6_sub2.id
  route_table_id = aws_route_table.LABO6-RoutingT.id
}

# Create aws_internet_gateway
resource "aws_internet_gateway" "LABO6-GW" {
  vpc_id = aws_vpc.VPC_LABO6.id
  tags = {
    Name = "LABO6-GW"
  }
}