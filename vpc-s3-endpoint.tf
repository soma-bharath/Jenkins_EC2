resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.main_vpc.id
  service_name = "com.amazonaws.us-gov-west-1.s3"
  route_table_ids = [data.aws_route_tables.private.id] 

  tags = {
    Name = "S3VPC"
    Date = local.current_date
    Env  = var.env
  }
}
