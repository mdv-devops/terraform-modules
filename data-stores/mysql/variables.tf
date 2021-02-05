variable "tags" {
  default = {
    Owner       = "MDV-devops"
    Environment = "Staging"
    Deployed_by = "terraform"
  }
}
variable "tags_prod" {
  default = {
    Owner       = "MDV-devops"
    Environment = "Production"
    Deployed_by = "terraform"
  }
}
variable "environment" {
  description = "The name of environment"
}
