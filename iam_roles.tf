resource "aws_iam_role" "Amazon_EC2_Jenkins" {
  assume_role_policy    = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"}}],\"Version\":\"2012-10-17\"}"
  description           = "Allows EC2 instances to call AWS services on your behalf."
  force_detach_policies = false
  managed_policy_arns   = ["arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",aws_iam_policy.s3_access_policy.arn]
  max_session_duration  = 3600
  name                  = "AmazonEC2Jenkins"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  depends_on            = [aws_iam_policy.s3_access_policy]
}

resource "aws_iam_instance_profile" "EC2_Jenkins" {
  name = "AmazonEC2Jenkins"
  role = aws_iam_role.Amazon_EC2_Jenkins.id
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "ec2_s3_access_policy"
  description = "Policy to allow EC2 instance to access S3 bucket for backups"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::my-jenkins-backup-bucket/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::my-jenkins-backup-bucket"
      }
    ]
  })
}
