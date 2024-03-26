locals {
  name              = var.name
  owner             = var.owner
  security_group_id = var.security_group_id
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  create            = (var.create ? 1 : 0)
  select            = (var.create ? 0 : 1)
}
data "aws_lb" "selected" {
  count = local.select
  tags = {
    Name = local.name
  }
}
resource "aws_lb" "new" {
  count = local.create
  name               = local.name
  internal           = false
  load_balancer_type = "network"
  security_groups    = [local.security_group_id]
  subnets            = [local.subnet_id]

  tags = {
    Name  = local.name
    Owner = local.owner
  }
}
# only generate targets if the network load balancer is created
resource "aws_lb_target_group" "port80" {
  depends_on = [
    aws_lb.new,
  ]
  count = local.create
  port     = 80
  protocol = "TCP"
  vpc_id   = local.vpc_id
  name     = "${local.name}-port80"
  health_check {
    protocol            = "HTTP"
    path                = "/ping" # this is a k8s built in path that returns a 200 status code
    interval            = 10
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
  tags = {
    Name  = "${local.name}-port80"
    Owner = local.owner
  }
}
resource "aws_lb_target_group" "port443" {
  depends_on = [
    aws_lb.new,
  ]
  count = local.create
  port     = 443
  protocol = "TCP"
  vpc_id   = local.vpc_id
  name     = "${local.name}-port443"
  health_check {
    protocol            = "HTTP"
    path                = "/ping" # this is a k8s built in path that returns a 200 status code
    interval            = 10
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
  tags = {
    Name  = "${local.name}-port443"
    Owner = local.owner
  }
}
resource "aws_lb_target_group" "port6443" {
  depends_on = [
    aws_lb.new,
  ]
  count = local.create
  port     = 6443
  protocol = "TCP"
  vpc_id   = local.vpc_id
  name     = "${local.name}-port6443"
  health_check {
    protocol            = "HTTP"
    path                = "/ping" # this is a k8s built in path that returns a 200 status code
    interval            = 10
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
  tags = {
    Name  = "${local.name}-port6443"
    Owner = local.owner
  }
}
# only generate listeners if the network load balancer is created
resource "aws_lb_listener" "port80" {
  depends_on = [
    aws_lb.new,
  ]
  count = local.create
  load_balancer_arn = aws_lb.new[0].arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port80[0].arn
  }
  tags = {
    Name  = "${local.name}-port80"
    Owner = local.owner
  }
}
resource "aws_lb_listener" "port443" {
  depends_on = [
    aws_lb.new,
  ]
  count = local.create
  load_balancer_arn = aws_lb.new[0].arn
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port443[0].arn
  }
  tags = {
    Name  = "${local.name}-port443"
    Owner = local.owner
  }
}
resource "aws_lb_listener" "port6443" {
  depends_on = [
    aws_lb.new,
  ]
  count = local.create
  load_balancer_arn = aws_lb.new[0].arn
  port              = "6443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port6443[0].arn
  }
  tags = {
    Name  = "${local.name}-port6443"
    Owner = local.owner
  }
}
