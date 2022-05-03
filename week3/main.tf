provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.web_instance_profile.id
  security_groups             = [aws_security_group.allow_http_ssh.name]
  availability_zone           = "us-west-2b"

  tags = {
    Name = "homework-week-3"
  }
  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash

mkdir -p /home/ec2-user/s3
cd /home/ec2-user/s3

aws s3 cp "s3://${var.bucket_name}/dynamodb-script.sh" .
aws s3 cp "s3://${var.bucket_name}/rds-script.sql" .

python3 -m http.server --bind 0.0.0.0 80 &
EOF
}


