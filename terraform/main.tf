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

resource "aws_iam_role" "ec2_role" {
  name               = "ec2_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
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
    description = "Autorise tout le trafic sortant"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    description = "Security Group for EC2 instance"
    Name        = "ec2_sg"
  }
}

resource "aws_security_group" "ec2_private_sg" {
  name        = "ec2_private_sg"
  description = "Autorise SSH uniquement depuis le SG de l'instance web"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH depuis l'instance web"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "Autorise tout le trafic sortant"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_private_sg"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.private_subnet_az
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "iia-2025"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  ebs_optimized          = true

  associate_public_ip_address = true

  metadata_options {
    http_tokens   = "required" # IMDSv2 obligatoire
    http_endpoint = "enabled"
  }

  tags = {
    Name = "EC2-Instance"
  }

  provisioner "local-exec" {
    command = "echo instance public :${self.public_ip} > ip.txt"
  }
}

resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "iia-2025"
  vpc_security_group_ids = [aws_security_group.ec2_private_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  ebs_optimized          = true

  associate_public_ip_address = false

  subnet_id = aws_subnet.private_subnet.id

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "EC2-Private-Instance"
  }

  provisioner "local-exec" {
    command = "echo instance private :${self.private_ip} >> ip.txt"
  }

}


