
resource "aws_internet_gateway" "egw" {
  vpc_id = aws_vpc.net.id

  tags = {
    Name = "main"
  }
}
resource "aws_eip" "nat_ip" {
 domain = "vpc"
}
resource "aws_nat_gateway" "nat_getway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "Egw NAT"
  }
  depends_on = [aws_internet_gateway.egw]
}

resource "aws_route_table" "frontend_rout" {
  vpc_id = aws_vpc.net.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_getway.id

  }
}
resource "aws_route_table" "backend_rout" {
  vpc_id = aws_vpc.net.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_getway.id

  }
}
resource "aws_route_table" "public_rout" {
  vpc_id = aws_vpc.net.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.egw.id 
  }
}
resource "aws_route_table_association" "publicattach" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rout.id
}
resource "aws_route_table_association" "frontattach" {
  subnet_id      = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.frontend_rout.id
}
resource "aws_route_table_association" "backattach" {
  subnet_id      = aws_subnet.backend_subnet.id
  route_table_id = aws_route_table.backend_rout.id
}
