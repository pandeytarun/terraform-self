resource "aws_secretsmanager_secret" "password" {
  name = "test-db-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

### DEploying RDS MySQL Instance ##

resource "aws_db_subnet_group" "default" {
  name = "main"
  subnet_ids = [
    aws_subnet.subnet1-public.id,
    aws_subnet.subnet2-public.id,
  ]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  identifier           = "testdb"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.medium"
  name                 = "mydb"
  username             = "dbadmin"
  password             = data.aws_secretsmanager_secret_version.password.secret_string
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.default.id
}
