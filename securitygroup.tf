aws_security_group.alb_sg

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Security group for the ALB"
  vpc_id      = "vpc-12345678" // Replace with your VPC ID

  // Define ingress rules if needed
  ingress {
    from_port   = 8080
    to_port     = 8080
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
