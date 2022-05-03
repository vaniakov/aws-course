resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "rds" {
  allocated_storage                   = 10
  engine                              = "mysql"
  engine_version                      = "5.7"
  instance_class                      = "db.t3.micro"
  db_name                             = var.rds_dbname
  username                            = "ivan"
  password                            = random_password.password.result
  parameter_group_name                = "default.mysql5.7"
  skip_final_snapshot                 = true
  vpc_security_group_ids              = [aws_security_group.allow_connect_to_mysql.id]
  iam_database_authentication_enabled = true
  availability_zone                   = "us-west-2b"
}
