
output "aws_db_instance_address" {
  value = aws_db_instance.db.address
}
output "aws_db_instance_port" {
  value = aws_db_instance.db.port
}
output "environment" {
  value = var.environment
}
