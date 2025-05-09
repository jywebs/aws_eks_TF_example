provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "eks-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(var.azs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[lookup(var.azs, each.key, 0)]
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each = toset(var.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[lookup(var.azs, each.key, 0)]
  availability_zone = each.value

  tags = {
    Name = "eks-private-${each.value}"
  }
}

resource "aws_eip" "nat" {
  for_each = toset(var.azs)

  vpc = true
  tags = {
    Name = "eks-nat-eip-${each.value}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  for_each = toset(var.azs)

  allocation_id = aws_eip.nat[each.value].id
  subnet_id     = aws_subnet.public[each.value].id

  tags = {
    Name = "eks-nat-gw-${each.value}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "eks-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = toset(var.azs)

  subnet_id      = aws_subnet.public[each.value].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = toset(var.azs)

  vpc_id = aws_vpc.main.id
  tags = {
    Name = "eks-private-rt-${each.value}"
  }
}

resource "aws_route" "private_nat_gateway" {
  for_each = toset(var.azs)

  route_table_id         = aws_route_table.private[each.value].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[each.value].id
}

resource "aws_route_table_association" "private" {
  for_each = toset(var.azs)

  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}