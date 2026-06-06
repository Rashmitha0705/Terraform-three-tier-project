# -------------------------
# VPC
# -------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "project-vpc"
  }
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-igw"
  }
}

# -------------------------
# Public Subnet 1
# -------------------------

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# -------------------------
# Public Subnet 2
# -------------------------

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

# -------------------------
# Frontend Private Subnet 1
# -------------------------

resource "aws_subnet" "frontend1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "frontend-private-subnet-1"
  }
}

# -------------------------
# Frontend Private Subnet 2
# -------------------------

resource "aws_subnet" "frontend2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "frontend-private-subnet-2"
  }
}

# -------------------------
# Backend Private Subnet 1
# -------------------------

resource "aws_subnet" "backend1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "backend-private-subnet-1"
  }
}

# -------------------------
# Backend Private Subnet 2
# -------------------------

resource "aws_subnet" "backend2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "backend-private-subnet-2"
  }
}



#NAT GATEWAY

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}


resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public1.id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}
#Public Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

#Private Route Table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

#Associate Public Subnets
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}


#Associate Frontend Subnets

resource "aws_route_table_association" "backend1" {
  subnet_id      = aws_subnet.backend1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "backend2" {
  subnet_id      = aws_subnet.backend2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "frontend1" {
  subnet_id      = aws_subnet.frontend1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "frontend2" {
  subnet_id      = aws_subnet.frontend2.id
  route_table_id = aws_route_table.private.id
}