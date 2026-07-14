//beanstalk-sg.tf

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "beanstalk" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d",
      "us-east-1f"
    ]
  }
}

resource "aws_security_group" "api_alb" {
  name        = "townhallus-api-alb-sg"
  description = "Allow HTTP and HTTPS traffic to API ALB"
	vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "townhallus"
    Name    = "townhallus-api-alb-sg"
  }
}

resource "aws_security_group" "api_ec2" {
  name        = "townhallus-api-ec2-sg"
  description = "Allow traffic from API ALB to Beanstalk EC2 instances"
	vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.api_alb.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "townhallus"
    Name    = "townhallus-api-ec2-sg"
  }
}