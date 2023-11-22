terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MainInternetGateway"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidr_1
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet2"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "MainNATGateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_instance" "kubernetes_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "KubernetesInstance"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for Private Instances"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    Name = "nginx-alb"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main_vpc.id

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

resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = "80"
  }

  tags = {
    Name = "NginxTargetGroup"
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "nginx_tg_attachment" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = aws_instance.kubernetes_instance.id
  port             = 80
}

resource "aws_route53_zone" "main" {
  name = "devopsmoveoassignment.space"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.devopsmoveoassignment.space"
  type    = "A"

  alias {
    name                   = aws_lb.nginx_alb.dns_name
    zone_id                = aws_lb.nginx_alb.zone_id
    evaluate_target_health = true
  }
}
