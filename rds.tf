#RDS needs at least 2 subnets in different AZs.

resource "aws_db_subnet_group" "db_subnet_group" {

  name = "project-db-subnet-group"

  subnet_ids = [
    aws_subnet.backend1.id,
    aws_subnet.backend2.id
  ]

  tags = {
    Name = "project-db-subnet-group"
  }
}

#MySQL RDS Instance

resource "aws_db_instance" "mysql" {

  identifier = "project-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = var.db_name
   username = var.db_username
  password = var.db_password

  skip_final_snapshot = true

  publicly_accessible = false

  multi_az = false

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "project-mysql"
  }
}