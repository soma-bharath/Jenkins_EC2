resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80" # Set your desired threshold
  alarm_description   = "This metric monitors EC2 CPU utilization of Jenkins machine"

  dimensions = {
    InstanceId = aws_instance.my_ec2.id
  }
  tags = {
    Name = "Jenkins-EC2"
    Date = local.current_date
    Env  = var.env
  }
depends_on=[aws_instance.my_ec2]
}
