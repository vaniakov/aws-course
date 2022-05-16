resource "aws_lb_target_group" "main" {
  name     = "${var.vpc_name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "private" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.private.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "public" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.public.id
  port             = 80
}

resource "aws_lb" "main" {
  name               = "${var.vpc_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}


resource "aws_security_group" "lb_sg" {
  name        = "allow_https"
  description = "Allow http,https inbound traffic."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
