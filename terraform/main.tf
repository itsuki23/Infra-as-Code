# prefix = taskleaf

# ------------------------------
#  vpc
# ------------------------------

resource "aws_vpc" "public" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "taskleaf-vpc"
  }
}

# ------------------------------
#  igw
# ------------------------------

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.public.id
  tags = {
    "Name" = "taskleaf-igw"
  }
}

# ------------------------------
#  route table
# ------------------------------

# public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.public.id
  tags = {
    "Name" = "taskleaf-public-rt"
  }
}
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id     = aws_internet_gateway.public.id
  destination_cidr_block = "0.0.0.0/0"
}

# private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.public.id
  tags = {
    "Name" = "taskleaf-private-rt"
  }
}

# ------------------------------
#  subnet
# ------------------------------

# public
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.public.id
  cidr_block              = "10.0.30.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "taskleaf-public-subnet-1a"
  }
}
resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.public.id
  cidr_block              = "10.0.31.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "taskleaf-public-subnet-1c"
  }
}
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

# private
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.public.id
  cidr_block              = "10.0.40.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "taskleaf-private-subnet-1a"
  }
}
resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.public.id
  cidr_block              = "10.0.41.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "taskleaf-private-subnet-1c"
  }
}
resource "aws_route_table_association" "private_1a" {
  subnet_id = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_1c" {
  subnet_id = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private.id
}

#