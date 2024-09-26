resource "aws_instance" "multitier" {
  ami           = "ami-07fd280bc5bbd1a95"
  instance_type = "t2.micro"
  tags = {
    Name = "multtier"
  }
  vpc_security_group_ids = [aws_security_group.sequrity_multitier.id]
  subnet_id = aws_subnet.public_subnet.id
}