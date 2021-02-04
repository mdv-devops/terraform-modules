data "terraform_remote_state" "mysql_data" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = var.region
  }
}
data "aws_ami" "latest_amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
data "aws_ami" "latest_ubuntu_20-04_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
data "aws_subnet" "selected" {
  for_each = data.aws_subnet_ids.default.ids
  id       = each.value
}
data "aws_vpc" "default" {}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "template_file" "user_data" {
  template = file("${path.module}/default_data.sh")
  vars = {
    db_address = data.terraform_remote_state.mysql_data.outputs.aws_db_instance_address
    db_port    = data.terraform_remote_state.mysql_data.outputs.aws_db_instance_port
  }
}
