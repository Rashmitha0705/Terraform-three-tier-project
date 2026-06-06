#Frontend Auto Scaling Group

resource "aws_autoscaling_group" "frontend_asg" {

  name = "frontend-asg"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.frontend1.id,
    aws_subnet.frontend2.id
  ]

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.frontend_tg.arn
  ]

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "frontend-server"
    propagate_at_launch = true
  }
}

#Backend Auto Scaling Group

resource "aws_autoscaling_group" "backend_asg" {

  name = "backend-asg"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.backend1.id,
    aws_subnet.backend2.id
  ]

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.backend_tg.arn
  ]

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "backend-server"
    propagate_at_launch = true
  }
}

