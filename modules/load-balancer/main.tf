resource "aws_lb" "app_lb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "frontend" {
  name     = var.frontend_tg
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "backend" {
  name     = var.backend_tg
  port     = 3500
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  #  health_check {
  #   path                = "/"
  #   protocol            = "HTTP"
  #   interval            = 30
  #   timeout             = 5
  #   healthy_threshold   = 3
  #   unhealthy_threshold = 2
  #   matcher             = "200-399"
  # }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 3500
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
