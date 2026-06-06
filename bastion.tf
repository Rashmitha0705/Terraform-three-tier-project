resource "aws_instance" "bastion" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public1.id

  key_name = "aws_login"

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = {
    Name = "bastion-host"
  }
}

#EIP

resource "aws_eip" "bastion_eip" {

  instance = aws_instance.bastion.id

  domain = "vpc"

  tags = {
    Name = "bastion-eip"
  }
}