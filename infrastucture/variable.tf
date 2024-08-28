variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_availability_zones" {
  type = map(string)
  default = {
  az-1 = "eu-west-1a"
  az-2 = "eu-west-1b"
  az-3 = "eu-west-1c"
    
  }

}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  type    = map(string)
  default = {
    ha_iac_project_private_subnet_1 = "10.0.0.0/24"
    ha_iac_project_private_subnet_2 = "10.0.1.0/24"
  }
}

variable "public_subnets_cidr" {
  type    = map(string)
  default = {
    ha_iac_project_public_subnet_1 = "10.0.10.0/24"
    ha_iac_project_public_subnet_2 = "10.0.11.0/24"
  }
}

variable "db_subnets_cidr" {
  type    = map(string)
  default = {
    ha_iac_project_db_subnet_1 = "10.0.20.0/24"
    ha_iac_project_db_subnet_2 = "10.0.21.0/24"
  }
}
