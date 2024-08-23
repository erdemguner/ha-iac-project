variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = {
    "ha_terraform_project-private_subnet-1" = 0
    "ha_terraform_project-private_subnet-2" = 1
  }
}

variable "public_subnets" {
  default = {
    "ha_terraform_project-public_subnet-1" = 0
    "ha_terraform_project-public_subnet-2" = 1
  }
}

variable "db_subnets" {
  default = {
    "ha_terraform_project-db_subnet_1" = 0
    "ha_terraform_project-db_subnet_2" = 1
  }
}
