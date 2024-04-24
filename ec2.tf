resource "aws_instance" "my_ec2" {
  instance_type               = "t2.large"
  ami                         = "ami-04fd4a41214d8887d" #CIS AMI ID in us-west-2 region
  subnet_id                   = data.aws_subnet.private_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
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
root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    encrypted             = true
    #kms_key_id            = data.aws_kms_key.my_key.arn  # Specify your KMS key ID
    delete_on_termination = true
  }

  # Additional EBS volume
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = 100
    encrypted             = true
    #kms_key_id            = data.aws_kms_key.my_key.arn  # Specify your KMS key ID
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash
set -xe
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install java-11-openjdk java-11-openjdk-devel -y
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "$password"
EOF
  tags = {
    Name = "Jenkins-EC2"
    Date = local.current_date
    Env  = var.env
  }
}
