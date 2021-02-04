
data "aws_ssm_parameter" "mysql_db_password" {
  name = "/test/mysql"
}
