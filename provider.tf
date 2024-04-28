terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"

}

locals {
  current_date = formatdate("YYYY-MM-DD", timestamp())
}

resource "null_resource" "fetch_jenkins_password" {
  depends_on = [aws_instance.my_ec2,aws_lb.Jenkins_Alb]
provisioner "local-exec" {
    command = <<EOT
      sudo chmod 700 jenkins-key.pem && \
      sleep 20 && \
      sudo ssh -o StrictHostKeyChecking=no -i "${path.module}/jenkins-key.pem" ec2-user@${aws_instance.my_ec2.private_ip} "sudo cat /apps/secrets/initialAdminPassword; sleep 30; sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent; sleep 30; sudo systemctl restart firewalld"

      
    EOT
  }   
}
