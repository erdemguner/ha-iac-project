resource "aws_rds_cluster" "ha-terraform-project-rds-cluster" {
  cluster_identifier = "ha-terraform-project-rds-cluster"
  engine             = "mysql"
  engine_version     = "8.0.39"
  db_cluster_instance_class = "db.m5d.large"
  allocated_storage       = 20
  storage_type            = "gp3"
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  # secretlar sektör standardı nasılsa güncellenecek (durula sor)
  master_username         = "admin"
  master_password         = "admin1234"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
 
}

resource "aws_db_subnet_group" "ha-terraform-project-db-subnet-group" {
  name = "ha-terraform-project-db-subnet-group"
  subnet_ids = [
    aws_subnet.ha-iac-project-db-subnet-1.id,
    aws_subnet.ha-iac-project-db-subnet-2.id
  ]

}

# resource "aws_rds_cluster_instance" "ha-terraform-project-rds-cluster-instance" {
#   count                = 1
#   identifier           = "ha-terraform-project-rds-cluster-instance-${count.index}"
#   cluster_identifier   = aws_rds_cluster.ha-terraform-project-rds-cluster.id
#   instance_class       = "db.t4g.micro"
#   engine               = aws_rds_cluster.ha-terraform-project-rds-cluster.engine
#   engine_version       = aws_rds_cluster.ha-terraform-project-rds-cluster.engine_version
#   publicly_accessible  = false
#   db_subnet_group_name = aws_db_subnet_group.ha-terraform-project-db-subnet-group.name

# }
