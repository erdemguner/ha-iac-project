resource "aws_vpc" "ha-terraform-project-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ha_terra_project_vpc"
  }

}
data "aws_availability_zones" "available" {}

resource "aws_subnet" "ha-iac-project-private-subnet-1" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  cidr_block        = var.private_subnets_cidr.ha_iac_project_private_subnet_1
  availability_zone = var.aws_availability_zones.az-1
  tags = {
    Name = "ha-iac-project-private-subnet_1"
    type = "private"
  }
}
resource "aws_subnet" "ha-iac-project-private-subnet-2" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  cidr_block        = var.private_subnets_cidr.ha_iac_project_private_subnet_2
  availability_zone = var.aws_availability_zones.az-2
  tags = {
    Name = "ha-iac-project-private-subnet_2"
    type = "private"
  }
}
resource "aws_subnet" "ha-iac-project-public-subnet-1" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  cidr_block        = var.public_subnets_cidr.ha_iac_project_public_subnet_1
  availability_zone = var.aws_availability_zones.az-1
  tags = {
    Name = "ha-iac-project-public-subnet-1"
    type = "public"
  }
}
resource "aws_subnet" "ha-iac-project-public-subnet-2" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  cidr_block        = var.public_subnets_cidr.ha_iac_project_public_subnet_2
  availability_zone = var.aws_availability_zones.az-2
  tags = {
    Name = "ha-iac-project-public-subnet-2"
    type = "public"
  }
}
resource "aws_subnet" "ha-iac-project-db-subnet-1" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  cidr_block        = var.db_subnets_cidr.ha_iac_project_db_subnet_1
  availability_zone = var.aws_availability_zones.az-1
  tags = {
    Name = "ha-iac-project-db-subnet-1"
    type = "private"
  }
}
resource "aws_subnet" "ha-iac-project-db-subnet-2" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  cidr_block        = var.db_subnets_cidr.ha_iac_project_db_subnet_2
  availability_zone = var.aws_availability_zones.az-2
  tags = {
    Name = "ha-iac-project-db-subnet-2"
    type = "private"
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ha-terraform-project-vpc.id
}

resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.ha-iac-project-public-subnet-1.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ha-terraform-project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ha-terraform-project-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}
resource "aws_route_table_association" "public_associations" {
  depends_on = [aws_subnet.ha-iac-project-public-subnet-1, aws_subnet.ha-iac-project-public-subnet-2]
  for_each = {
    "subnet_1" = aws_subnet.ha-iac-project-public-subnet-1.id
    "subnet_2" = aws_subnet.ha-iac-project-public-subnet-2.id
  }
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = each.value
}

resource "aws_route_table_association" "private-associations" {
  depends_on = [aws_subnet.ha-iac-project-private-subnet-1, aws_subnet.ha-iac-project-private-subnet-2]
  for_each = {
    subnet_1 = aws_subnet.ha-iac-project-private-subnet-1.id,
    subnet_2 = aws_subnet.ha-iac-project-private-subnet-2.id }

  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = each.value

}

resource "aws_route_table_association" "db-private-associations" {
  depends_on     = [aws_subnet.ha-iac-project-db-subnet-1, aws_subnet.ha-iac-project-db-subnet-2]
  for_each       = {
    subnet_1 = aws_subnet.ha-iac-project-db-subnet-1.id,
    subnet_2 = aws_subnet.ha-iac-project-db-subnet-2.id
  }
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = each.value
}

