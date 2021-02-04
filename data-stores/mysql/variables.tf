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
variable "environment" {
  description = "The name of environment"
}
