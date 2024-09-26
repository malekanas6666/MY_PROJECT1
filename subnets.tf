
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.net.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public"
  }
    map_public_ip_on_launch = true
}

resource "aws_subnet" "frontend_subnet" {
  vpc_id     = aws_vpc.net.id
  availability_zone   = "eu-central-1a"
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "frontend_subnet"
  }
}

resource "aws_subnet" "backend_subnet" {
  vpc_id     = aws_vpc.net.id
    availability_zone   = "eu-central-1b"
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "backend_subnet"
  }
}
resource "aws_db_subnet_group" "subnet_groub" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend_subnet.id, aws_subnet.backend_subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}