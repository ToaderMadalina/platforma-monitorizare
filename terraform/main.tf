# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
  }
}

# ========================
# S3 Bucket for Monitoring Data
# ========================
resource "aws_s3_bucket" "monitoring_data" {
  bucket = "monitoring-data"

  force_destroy = true

  tags = {
    Name = "Monitoring Data Bucket"
  }
}

resource "aws_s3_bucket_acl" "monitoring_acl" {
  bucket = aws_s3_bucket.monitoring_data.id
  acl    = "private"
}

# ========================
# SSH Key Pair
# ========================
resource "tls_private_key" "monitoring_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "monitoring_key" {
  key_name   = "monitoring-key"
  public_key = tls_private_key.monitoring_key.public_key_openssh
}

# ========================
# Security Group
# ========================
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
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
}

# ========================
# EC2 Instance (LocalStack dummy)
# ========================
resource "aws_instance" "monitoring_instance" {
  ami           = "ami-localstack"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.monitoring_key.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Monitoring-Instance"
  }
}

