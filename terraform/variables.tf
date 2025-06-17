variable "aws_region" {
  default = "eu-west-3" # Paris
}

variable "ami_id" {
  description = "AMI Ubuntu 24.04"
  default     = "ami-04ec97dc75ac850b1" # Vérifie l'AMI dans ta région
}

variable "public_key_path" {
  description = "Chemin vers la clé publique"
  default     = "~/.ssh/iia-2025.pub"
}

variable "vpc_id" {
  description = "ID du VPC dans lequel déployer les ressources"
  default     = "vpc-03480d50e3190e317" # Remplace par l'ID de ton VPC
}
