resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.vpc_name}-net-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-west-2b"

  tags = {
    Name = "${var.vpc_name}-net-private"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-rt-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_instance" "nat" {
  ami                         = "ami-003af5caf3be398ca"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.nat.id]
  source_dest_check           = false
  subnet_id                   = aws_subnet.public.id

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

resource "aws_security_group" "nat" {
  name        = "${var.vpc_name}-nat-sg"
  description = "allow traffic from private subnet to the nat instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [aws_security_group.allow_http_ssh_from_public_subnet.id]
  }

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route" "route-public" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_instance.nat.id
}
