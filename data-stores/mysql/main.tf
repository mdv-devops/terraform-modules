resource "aws_db_instance" "db" {
  identifier           = "${var.environment}-mysql-db"
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  parameter_group_name = "default.mysql5.7"
  username             = "admin"
  password             = data.aws_ssm_parameter.mysql_db_password.value
  apply_immediately    = true
  skip_final_snapshot  = true
  tags                 = merge(var.environment == "prod" ? var.tags_prod : var.tags, { Name = "${var.environment}-mysql-db" })
}
