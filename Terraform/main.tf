provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/swilliams/.aws/creds"
  profile                 = "terraform"
}

#Create VPC in us-east-1
resource "aws_vpc" "vpc_assessment" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-assessment"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  vpc_id   = aws_vpc.vpc_assessment.id
  tags = {
    Name = "igw-assessment"
  }
}

#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc_training.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "subnet_1-assessment"
  }
}

#Create route table in us-east-1
resource "aws_route_table" "internet_route" {
  vpc_id   = aws_vpc.vpc_assessment.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Create SG for only TCP/80, TCP/22 and outbound access
resource "aws_security_group" "assessment-sg" {
  name        = "assessment-sg"
  description = "Allow port 80 and 22 traffic"
  vpc_id      = aws_vpc.vpc_assessment.id
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 22 from anywhere for redirection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

resource "aws_key_pair" "assessment-keypair" {
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "assessment-instance" {
  ami             = "ami-0c94855ba95c71c99"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.assessment-sg.id]
  associate_public_ip_address = true
  key_name        = "assessment-key"
  count           = 2 # create four similar EC2 instances
  tags = {
    Name = "ec2-assessment-0${count.index + 2}.example.com"
    Environment = "assessment"
    }

}
