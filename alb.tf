#Frontend Target Group

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {

    enabled             = true
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

#Public ALB

resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.public_alb_sg.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}

#Public ALB Listener

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.public_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

#Backend Target Group

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}


#Internal ALB

resource "aws_lb" "internal_alb" {
  name               = "inside-alb"
  internal           = true
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.internal_alb_sg.id
  ]

  subnets = [
    aws_subnet.backend1.id,
    aws_subnet.backend2.id
  ]
}

# Internal ALB Listener
resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}