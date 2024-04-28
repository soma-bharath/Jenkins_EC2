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
  depends_on = [aws_instance.my_ec2]
provisioner "local-exec" {
    command = <<EOT
      sleep 20 && \
      sudo ssh -i "${path.module}/jenkins-key.pem" ec2-user@${aws_instance.my_ec2.private_ip} "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
      
    EOT
  }   
}
