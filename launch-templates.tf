data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


#Frontend Launch Template

resource "aws_launch_template" "frontend_lt" {

  name_prefix   = "frontend-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = "aws_login"

  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

   user_data = base64encode(
  templatefile(
    "${path.module}/userdata/frontend.sh.tpl",
    {
      internal_alb_dns = aws_lb.internal_alb.dns_name
    }
  )
)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "frontend-server"
    }
  }
}

#Backend Launch Template

resource "aws_launch_template" "backend_lt" {

  name_prefix   = "backend-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.backend_sg.id
  ]

  user_data = base64encode(
    file("${path.module}/userdata/backend.sh.tpl")
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "backend-server"
    }
  }
}