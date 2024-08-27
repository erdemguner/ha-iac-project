resource "aws_rds_cluster" "ha-terraform-project-rds-cluster" {
  cluster_identifier = "ha-terraform-project-rds-cluster"
  engine             = "aurora-mysql"
  engine_version     = "3.07"
  availability_zones = ["us-west-2a", "us-west-2b"]
  # secretlar sektör standardı nasılsa güncellenecek (durula sor)
  master_username         = "admin"
  master_password         = "admin1234"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"

}

resource "aws_db_subnet_group" "ha-terraform-project-db-subnet-group" {
  name       = "ha-terraform-project-db-subnet-group"
  subnet_ids = ["aws_subnet.ha_terraform_project-db_subnet_1", "aws_subnet.ha_terraform_project-db_subnet_2"]

}

resource "aws_rds_cluster_instance" "ha-terraform-project-rds-cluster-instance" {
  count                = 2
  identifier           = "ha-terraform-project-rds-cluster-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.ha-terraform-project-rds-cluster.id
  instance_class       = "db.t3.medium"
  engine               = aws_rds_cluster.ha-terraform-project-rds-cluster.engine
  engine_version       = aws_rds_cluster.ha-terraform-project-rds-cluster.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.ha-terraform-project-db-subnet-group.name
}
