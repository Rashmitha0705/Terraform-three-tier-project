output "public_alb_dns" {

  description = "Public ALB DNS Name"

  value = aws_lb.public_alb.dns_name
}

output "internal_alb_dns" {

  description = "Internal ALB DNS Name"

  value = aws_lb.internal_alb.dns_name
}

output "rds_endpoint" {

  description = "RDS Endpoint"

  value = aws_db_instance.mysql.address
}

output "bastion_public_ip" {

  description = "Bastion Public IP"

  value = aws_eip.bastion_eip.public_ip
}