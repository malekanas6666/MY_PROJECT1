resource "aws_instance" "bastion" {
  ami           = "ami-07fd280bc5bbd1a95"
  instance_type = "t2.micro"
  tags = {
    Name = "BastionHost"
  }
vpc_security_group_ids = [aws_security_group.sequrity_bastion.id]
subnet_id = aws_subnet.public_subnet.id
 key_name      = aws_key_pair.ssh_key.key_name 
 
}
resource "aws_eip" "web_ip" {
  instance = aws_instance.bastion.id
}