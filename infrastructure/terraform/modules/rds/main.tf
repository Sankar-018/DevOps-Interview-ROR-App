resource "aws_db_subnet_group" "rds" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "13.21"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  port                    = 5432
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  skip_final_snapshot     = true
  publicly_accessible     = false

  vpc_security_group_ids  = [var.security_group_id]

  tags = {
    Name = var.db_identifier
  }
}

