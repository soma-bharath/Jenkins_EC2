data "aws_vpc" "main_vpc" {

  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Subnet-Type"
    values = ["private"]
  }
}

data "aws_subnet" "private_subnets" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Subnet-Type"
    values = ["public"]
  }
}

data "aws_subnet" "public_subnet_1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public_subnet_1"]
  }
}

data "aws_subnet" "private_subnet_1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private_subnet_1"]
  }
}

data "aws_subnet" "public_subnets" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}
/*
data "aws_kms_key" "my_key" {
  key_id = "arn:aws:kms:region:account-id:key/key-id" #enter your existing kms key id
}
*/

data "null_resource" "fetch_jenkins_password" {
  provisioner "remote-exec" {
    inline = [
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.keypair.private_key_pem
      host        = aws_instance.my_ec2.private_ip
    }
  }
depends_on=[aws_instance.my_ec2,aws_lb.Jenkins_Alb,aws_lb_target_group.Jenkins_target_group]
}

output "jenkins_password" {
  value = data.null_resource.fetch_jenkins_password.result
}
