resource "aws_vpc" "remotex-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "remotex-vpc"
  }
}

resource "aws_internet_gateway" "remotex-igw" {
  vpc_id = aws_vpc.remotex-vpc.id

  tags = {
    Name = "remotex-igw"
  }
}

resource "aws_subnet" "remotex-pub-sub" {
  cidr_block              = "10.10.1.0/24"
  vpc_id                  = aws_vpc.remotex-vpc.id
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "remotex-pub-sub"
  }
}

resource "aws_subnet" "remotex-pri-sub" {
  cidr_block              = "10.10.2.0/24"
  vpc_id                  = aws_vpc.remotex-vpc.id
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "remotex-pri-sub"
  }
}

resource "aws_route_table" "remotex-pub-rt" {
  vpc_id = aws_vpc.remotex-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.remotex-igw.id
  }

  tags = {
    Name = "remotex-pub-rt"
  }
}

resource "aws_route_table" "remotex-pri-rt" {
  vpc_id = aws_vpc.remotex-vpc.id

  tags = {
    Name = "remotex-pri-rt"
  }
}

resource "aws_route_table_association" "remotex-pub-rt-asso" {
  route_table_id = aws_route_table.remotex-pub-rt.id
  subnet_id      = aws_subnet.remotex-pub-sub.id
}

resource "aws_route_table_association" "remotex-pri-rt-asso" {
  route_table_id = aws_route_table.remotex-pri-rt.id
  subnet_id      = aws_subnet.remotex-pri-sub.id
}