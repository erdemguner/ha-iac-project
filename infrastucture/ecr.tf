resource "aws_ecr_repository" "ha-terraform-project-image-repository" {
  name                 = "ha-terraform-project-image-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}