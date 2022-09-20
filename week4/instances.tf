resource "aws_instance" "public" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]
  subnet_id                   = aws_subnet.public.id

  tags = {
    Name = "${var.vpc_name}-public"
  }
  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash
yum update –y
yum install -y httpd
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>This is WebServer from public subnet </h1></html>" > index.html
EOF
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "private" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.allow_http_ssh_from_public_subnet.id]
  subnet_id                   = aws_subnet.private.id
  depends_on                  = [aws_instance.nat]

  tags = {
    Name = "${var.vpc_name}-private"
  }
  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash
yum update –y
yum install -y httpd
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>This is WebServer from private subnet </h1></html>" > index.html
EOF
}

resource "aws_security_group" "allow_http_ssh_from_public_subnet" {
  name        = "allow_http_ssh_from_public_subnet"
  description = "Allow http,ssh,icmp inbound traffic from the public subnet."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  ingress {
    description = "HTTP from public subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
