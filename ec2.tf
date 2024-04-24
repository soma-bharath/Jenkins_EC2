resource "aws_instance" "my_ec2" {
  instance_type               = "t2.micro"
  ami                         = "ami-04fd4a41214d8887d" #CIS AMI ID in us-west-2 region
  subnet_id                   = data.aws_subnet.private_subnet_1.id
  vpc_security_group_ids      = [data.aws_security_group.jenkins-Security-Group.id]
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.EKS-EC2.name
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.keypair.private_key_pem
    host        = aws_instance.my_ec2.public_ip
  }
  
/*
  provisioner "file" {
    source      = "${path.module}/jenkins-key.pem"
    destination = "/home/ec2-user/.ssh/jenkins-key.pem"
  }
*/
  user_data = <<EOF
#!/bin/bash
set -x
sudo yum update -y
sudo yum install java-1.8.0-openjdk-devel -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl start jenkins
EOF
  tags = {
    Name = "Jenkins-EC2"
    Date = local.current_date
    Env  = var.env
  }
}
