resource "aws_s3_bucket" "jenkins_backup" {
  bucket = "my-jenkins-backup-bucket"
  
  versioning {
    enabled = true
  }

  tags = {
    Name = "Jenkins-backup-bucket"
    Date = local.current_date
    Env  = var.env
  }
}
