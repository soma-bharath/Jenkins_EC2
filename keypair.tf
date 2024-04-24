resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = "jenkins-key"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${path.module}/jenkins-key.pem"
  content  = tls_private_key.keypair.private_key_pem
}
