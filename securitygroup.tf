resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Security group for the ALB"
  vpc_id      = data.aws_vpc.main_vpc.id

  // Define ingress rules if needed
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic from anywhere
  }

  // Define egress rules if needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic to anywhere
  }
}


resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for the ec2"
  vpc_id      = data.aws_vpc.main_vpc.id

  // Define ingress rules if needed
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    security_group_id      = aws_security_group.alb_sg.id
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    security_group_id      = aws_security_group.alb_sg.id
    #cidr_blocks = ["0.0.0.0/0"] // Allow traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    security_group_id      = aws_security_group.alb_sg.id
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic from anywhere
  }

  // Define egress rules if needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic to anywhere
  }
}
