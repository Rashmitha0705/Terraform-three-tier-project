#SNS Topic

resource "aws_sns_topic" "alerts" {

  name = "project-alerts"

}

variable "alert_email" {
  description = "Email for CloudWatch alerts"
}

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"

  endpoint = var.alert_email
}

# alarm for fromtend load balancer

resource "aws_cloudwatch_metric_alarm" "frontend_alarm" {

  alarm_name = "frontend-unhealthy-targets"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "UnHealthyHostCount"

  namespace = "AWS/ApplicationELB"

  period = 60

  statistic = "Average"

  threshold = 0

  dimensions = {
    LoadBalancer = aws_lb.public_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.frontend_tg.arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

#Backend ALB Alarm

resource "aws_cloudwatch_metric_alarm" "backend_alarm" {

  alarm_name = "backend-unhealthy-targets"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "UnHealthyHostCount"

  namespace = "AWS/ApplicationELB"

  period = 60

  statistic = "Average"

  threshold = 0

  dimensions = {
    LoadBalancer = aws_lb.internal_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.backend_tg.arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

#RDS CPU Alarm

resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {

  alarm_name = "rds-high-cpu"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/RDS"

  period = 300

  statistic = "Average"

  threshold = 70

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.id
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}