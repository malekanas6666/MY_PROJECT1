resource "aws_instance" "private_instance" {
  ami           = "ami-07fd280bc5bbd1a95"
  instance_type = "t2.micro"
  tags = {
    Name = "multtiertest"
  }
  vpc_security_group_ids = [aws_security_group.sequrity_private.id]
  subnet_id = aws_subnet.frontend_subnet.id
  key_name      = aws_key_pair.inkey.key_name 
}