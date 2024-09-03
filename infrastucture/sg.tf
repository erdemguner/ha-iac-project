resource "aws_security_group" "rds-sg" {
  name   = "rds_sg"
  vpc_id = aws_vpc.ha-terraform-project-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb-sg" {
  name   = "lb_sg"
  vpc_id = aws_vpc.ha-terraform-project-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 433
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  }
}

resource "aws_security_group" "app-sg" {
  name   = "app_sg"
  vpc_id = aws_vpc.ha-terraform-project-vpc.id
  ingress {
    from_port   = 433
    to_port     = 433
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}