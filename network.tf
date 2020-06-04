resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_default_subnet" "default_subnet" {
  availability_zone = var.availability_zone
}

resource "aws_security_group" "privx-db" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    cidr_blocks = [aws_default_vpc.default.cidr_block]
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PRIVXDB"
    Terraform = "True"
  }
}

resource "aws_security_group" "privx-redis" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    cidr_blocks = [aws_default_vpc.default.cidr_block]
    from_port   = 6379
    protocol    = "tcp"
    to_port     = 6379
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PRIVXREDIS"
    Terraform = "True"
  }
}

resource "aws_security_group" "privx" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [aws_default_vpc.default.cidr_block]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PRIVX"
    Terraform = "True"
  }
}


resource "aws_security_group" "privx-webproxy" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    cidr_blocks = [aws_default_vpc.default.cidr_block]
    from_port   = 18080
    protocol    = "tcp"
    to_port     = 18080
  }
  ingress {
    cidr_blocks = [aws_default_vpc.default.cidr_block]
    from_port   = 18443
    protocol    = "tcp"
    to_port     = 18443
  }
  ingress {
    cidr_blocks = [aws_default_vpc.default.cidr_block]
    from_port   = 1344
    protocol    = "tcp"
    to_port     = 1344
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PRIVXWEBPROXY"
    Terraform = "True"
  }
}

resource "aws_security_group" "privx-carrier" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PRIVXCARRIER"
    Terraform = "True"
  }
}