resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"             # Specify the key algorithm (RSA, ECDSA, etc.)
  rsa_bits  = 2048 
}
resource "aws_key_pair" "ssh_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.ssh_key.public_key_openssh  # استخدم المفتاح العام اللي اتولد
}

resource "local_file" "private_key" {
  filename = "${path.module}/bastion-key.pem"  # اسم الملف الذي سيتم حفظه
  content  = tls_private_key.ssh_key.private_key_pem  # محتوى المفتاح الخاص
}
resource "tls_private_key" "inkey" {
  algorithm = "RSA"             # Specify the key algorithm (RSA, ECDSA, etc.)
  rsa_bits  = 2048 
}
resource "aws_key_pair" "inkey" {
  key_name   = "instance_key"
  public_key = tls_private_key.inkey.public_key_openssh  # استخدم المفتاح العام اللي اتولد
}
resource "local_file" "instance_key" {
  filename = "${path.module}/instance-key.pem"  # اسم الملف الذي سيتم حفظه
  content  = tls_private_key.inkey.private_key_pem  # محتوى المفتاح الخاص
}
resource "aws_security_group" "sequrity_bastion" {
  name        = "bastion-sg"
  description = "Security group for the Bastion Host"
  vpc_id = aws_vpc.net.id
  ingress {
    description = "Allow all trafic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]  
  }
    ingress {
    description      = "Allow SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["102.190.145.239/32"]  
    }
      egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sequrity_db" {
  name   = "sequrity_db"
  vpc_id = aws_vpc.net.id
}

resource "aws_security_group_rule" "sequrity_db_rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id  = aws_security_group.sequrity_bastion.id 
  security_group_id = aws_security_group.sequrity_db.id
}


resource "aws_security_group" "sequrity_multitier" {
  name        = "multitier-sg"
  description = "Security group for the Bastion Host"
  vpc_id = aws_vpc.net.id
  ingress {
      from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "sequrity_private" {
  name   = "sequrity_private_instance"
  vpc_id = aws_vpc.net.id
    ingress {
      from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = ["10.0.1.213/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}



