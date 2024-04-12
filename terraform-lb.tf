resource "aws_instance" "demo11" {
    count = 2
    ami = var.ami
    instance_type = var.instance_type
    key_name = "lab4-key"
    subnet_id         = count.index == 0 ? "subnet-044f829aa2089d0e8": "subnet-0c532559ebc567734"
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    depends_on = [aws_security_group.instance_sg]
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-044f829aa2089d0e8", /*, "subnet-068d842ffe6ea82cb",*/ "subnet-0ec4e2b95810e319f", /*"subnet-0dbbabcd430b1961d",*/ "subnet-0c532559ebc567734"]
  depends_on = [aws_security_group.lb_sg]
}

resource "aws_lb_target_group" "tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-00c60af8cb6e14206"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on = [aws_lb.lb]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.demo11[count.index].id
  port             = 80
  depends_on = [aws_lb_target_group.tg]
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_public_ip_lb" {
  value = aws_instance.demo11[*].public_ip
}

output "ec2_dns" {
  value = aws_instance.demo11[*].public_dns
}

output "lb_dns" {
  value = aws_lb.lb.dns_name
}
variable "ami" {
    default = "ami-0fb391cce7a602d1f"
}
variable "instance_type" {
    default = "t2.micro"
}
