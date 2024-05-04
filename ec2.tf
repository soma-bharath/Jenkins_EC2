resource "aws_instance" "my_ec2" {
  instance_type               = "t2.large"
  ami                         = "ami-050d5e0efb5579230" #CIS AMI ID in us-west-2 region
  subnet_id                   = data.aws_subnet.private_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.EC2_Jenkins.name
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
    volume_size           = 500
    encrypted             = true
    #kms_key_id            = data.aws_kms_key.my_key.arn  # Specify your KMS key ID
    delete_on_termination = true
  }

  # Additional EBS volume
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = 1000
    encrypted             = true
    #kms_key_id            = data.aws_kms_key.my_key.arn  # Specify your KMS key ID
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash
set -xe
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir /apps
sudo mount /dev/nvme1n1 /apps
sudo echo "/dev/nvme1n1 /apps ext4 defaults,nofail 0 2" >> sudo /etc/fstab
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://downloads.cloudbees.com/cje/rolling/rpm/jenkins.repo
sudo rpm --import https://downloads.cloudbees.com/jenkins-enterprise/rolling/rpm/cloudbees.com.key
sudo yum upgrade -y
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm --nogpgcheck
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo yum install java-11-amazon-corretto-devel -y
sudo wget https://jenkins-downloads.cloudbees.com/cje/rolling/rpm/RPMS/noarch/jenkins-2.346.4.1-1.1.noarch.rpm
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y --skip-broken
sudo yum install jenkins-2.346.4.1-1.1.noarch.rpm -y
sudo systemctl start jenkins
sudo chmod 777 -R /apps/
sudo systemctl stop jenkins
sleep 5
sudo sed -i 's#^JENKINS_HOME=.*#JENKINS_HOME="/apps/"#' /etc/sysconfig/jenkins
sleep 5
sudo systemctl start jenkins
sleep 5
sudo systemctl enable jenkins
sleep 20
sudo yum install firewalld -y
sleep 20
sudo systemctl start firewalld
sleep 40
sudo systemctl enable firewalld
sleep 30
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sleep 30
sudo systemctl restart firewalld
password=$(sudo cat /apps/secrets/initialAdminPassword)
echo "$password"
EOF
  tags = {
    Name = "Jenkins-EC2"
    Date = local.current_date
    Env  = var.env
  }
depends_on = [aws_security_group.ec2_sg,aws_iam_role.Amazon_EC2_Jenkins]
}
