variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}
variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}
variable "region" {
  description = "The region name for all resources"
  type        = string
}
variable "tags" {
  default = {
    Owner       = "MDV-devops"
    Environment = "Staging"
  }
}
variable "tags_prod" {
  default = {
    Owner       = "MDV-devops"
    Environment = "Production"
  }
}
variable "ingress_ports" {
  description = "The ports for SG"
  default     = ["80", "443"]
}
variable "instance_type" {
  description = "AWS instance type"
  default     = "t2.micro"
}
variable "instance_type_prod" {
  description = "AWS instance type"
  default     = "t2.micro"
}
locals {
  environment    = data.terraform_remote_state.mysql_data.outputs.environment
  any_port       = 0
  http_port      = 80
  any_cidr_block = ["0.0.0.0/0"]
  any_protocol   = "-1"
  http_protocol  = "tcp"

}
