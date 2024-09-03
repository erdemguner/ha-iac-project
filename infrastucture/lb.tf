resource "aws_lb" "ha-iac-project-alb" {
  name               = "ha-iac-project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.ha-iac-project-public-subnet-1.id, aws_subnet.ha-iac-project-public-subnet-2.id]

  enable_deletion_protection = false # böyle yapılıyomuş, neden lazım, durula sorulacak?
}

resource "aws_lb_target_group" "ha-iac-project-tg" {
  name = "eguner-live-tg"
  port = 443 # sertifika koyduk diye böyle mi yapacağız heralde, sadece app ile konuşacak
  protocol = "HTTPS"
  vpc_id   = aws_vpc.ha-terraform-project-vpc.id
}

# Listener for HTTP (Redirect to HTTPS)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ha-iac-project-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301" #böyle yapılıyomuş hata çükü??
    }
  }
}

# Listener for HTTPS
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ha-iac-project-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" #???

  certificate_arn = var.ssl-certificate-id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ha-iac-project-tg.arn
  }
}

# ### bura ECS fargete falan bişeylerden gelcek galiba???

# resource "aws_lb_target_group_attachment" "ha-iac-project-tg-attachment" {
#   target_group_arn = aws_lb_target_group.ha-iac-project-tg.arn
#   target_id        = ???????????????
#   port             = 80
# }