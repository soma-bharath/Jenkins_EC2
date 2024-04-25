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
/*
resource "null_resource" "fetch_jenkins_password" {
  depends_on = [aws_instance.my_ec2]

  provisioner "local-exec" {
    command = "sudo aws ssm start-session --target ${aws_instance.my_ec2.id} --document-name AWS-StartShell"

    interpreter = ["bash", "-c"]

    environment = {
      "PATH" = "/usr/local/bin:/usr/bin:/bin"
    }

    # Use sensitive to hide output containing the initial password
    sensitive = true
  }
}

output "jenkins_initial_password" {
  value     = null_resource.fetch_jenkins_password.triggers
  sensitive = true
}
*/
