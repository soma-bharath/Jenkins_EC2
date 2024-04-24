
resource "aws_lb" "Jenkins_Alb" {
  name               = "Jenkins_Alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for j in data.aws_subnet.public_subnets : j.id]
  tags = {
    Name = "Jenkins_Alb"
    Date = local.current_date
    Env  = var.env
  }
}

resource "aws_lb_target_group" "Jenkins_target_group" {
  name        = "Jenkins_target_group"
  port        = 8080
  protocol    = "HTTP"
  target_type = 
  vpc_id      =  data.aws_vpc.main_vpc.id
  tags = {
    Name = "Jenkins_target_group"
    Date = local.current_date
    Env  = var.env
  }
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.Jenkins_Alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Jenkins_target_group.arn
  }
}
