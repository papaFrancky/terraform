
resource aws_iam_role webservers {
  name                  = "webservers"
  description           = "IAM role for web servers"
  assume_role_policy    = file("${path.module}/files/ec2-trust.json")

  tags = {
      Name = "webservers"
  }
}


resource aws_iam_instance_profile webservers {
  name      = "webservers"
  role      = aws_iam_role.webservers.name
}


resource aws_iam_role_policy ec2-describe-instances {
  name      = "ec2-describe-instances"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/ec2-describe-instances.json")
}


resource aws_iam_role_policy ec2-describe-tags {
  name      = "ec2-describe-tags"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/ec2-describe-tags.json")
}


resource aws_iam_role_policy ec2-access {
  name      = "ec2-access"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/ec2-access.json")
}


resource aws_iam_role_policy route53-upsert-records {
  name      = "route53-upsert-records"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/route53-upsert-records.json")
}


resource aws_iam_role_policy s3-access {
  name      = "s3-access"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/s3-access.json")
}

