
resource "aws_lb" "Jenkins_Alb" {
  name               = "Jenkins-Alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for j in data.aws_subnet.public_subnets : j.id]
  security_groups    = [aws_security_group.alb_sg.id]
  tags = {
    Name = "Jenkins-Alb"
    Date = local.current_date
    Env  = var.env
  }
depends_on = [aws_instance.my_ec2]
}

resource "aws_lb_target_group" "Jenkins_target_group" {
  name        = "Jenkins-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  data.aws_vpc.main_vpc.id
  tags = {
    Name = "Jenkins-target-group"
    Date = local.current_date
    Env  = var.env
  }
depends_on = [aws_instance.my_ec2,aws_lb.Jenkins_Alb]
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.Jenkins_Alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Jenkins_target_group.arn
  }
depends_on = [aws_lb_target_group.Jenkins_target_group]
}

resource "aws_lb_target_group_attachment" "example_attachment" {
  target_group_arn = aws_lb_target_group.Jenkins_target_group.arn
  target_id        = aws_instance.my_ec2.id
}
