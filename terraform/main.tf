terraform {
  backend "s3" {
    bucket = "tfstate-ec2"                   # Ton bucket S3 existant
    key    = "webapp/prod/terraform.tfstate" # Nom du fichier d’état dans le bucket
    region = "eu-west-3"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Autorise SSH et HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "iia-2025"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "EC2-Instance"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip.txt"
  }
}
