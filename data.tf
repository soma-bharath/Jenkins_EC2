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

data "aws_security_group" "jenkins-Security-Group" {
  name = "jenkins-ec2-sg"
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

data "aws_subnet" "public_subnets" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}
/*
data "aws_kms_key" "my_key" {
  key_id = "arn:aws:kms:region:account-id:key/key-id" #enter your existing kms key id
}
*/
