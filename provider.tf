terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"

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
      sudo ssh -o StrictHostKeyChecking=no -i "${path.module}/jenkins-key.pem" ec2-user@${aws_instance.my_ec2.private_ip} "sudo cat /apps/secrets/initialAdminPassword"   
    EOT
  }   
}

resource "null_resource" "setup_backup" {
  provisioner "file" {
    source      = "jenkinsbackup.sh"
    destination = "/tmp/jenkinsbackup.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.keypair.private_key_pem
      host        = aws_instance.my_ec2.private_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/jenkinsbackup.sh /usr/local/bin/jenkinsbackup.sh",
      "sudo chmod +x /usr/local/bin/jenkinsbackup.sh",
      "echo '0 2 * * * /usr/local/bin/jenkinsbackup.sh' | sudo tee -a /etc/crontab > /dev/null"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.keypair.private_key_pem
      host        = aws_instance.my_ec2.private_ip
    }
  }

  depends_on = [aws_instance.my_ec2]
}
