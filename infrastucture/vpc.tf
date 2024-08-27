resource "aws_vpc" "ha-terraform-project-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ha_terra_project_vpc"
  }

}
data "aws_availability_zones" "available" {}

resource "aws_subnet" "ha-terraform-project-private-subnets" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  for_each          = var.private_subnets
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name = each.key
    type = "private"
  }
}

resource "aws_subnet" "ha-terraform-project-public-subnets" {
  vpc_id                  = aws_vpc.ha-terraform-project-vpc.id
  for_each                = var.public_subnets
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 10)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true
  tags = {
    Name = each.key
    type = "public"
  }
}

resource "aws_subnet" "ha-terraform-project-db-subnets" {
  vpc_id            = aws_vpc.ha-terraform-project-vpc.id
  for_each          = var.db_subnets
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 20)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name = each.key
    type = "private"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ha-terraform-project-vpc.id
}

resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.ha-terraform-project-private-subnets["ha_terraform_project-private_subnet-1"].id
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
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "public-associations" {
  depends_on = [aws_subnet.ha-terraform-project-public-subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.ha-terraform-project-public-subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private-associations" {
  depends_on     = [aws_subnet.ha-terraform-project-private-subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.ha-terraform-project-private-subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "db-private-associations" {
  depends_on     = [aws_subnet.ha-terraform-project-db-subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.ha-terraform-project-db-subnets
  subnet_id      = each.value.id
}

