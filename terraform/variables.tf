variable "aws_region" {
  default = "eu-west-3" # Paris
  type    = string
}

variable "ami_id" {
  description = "AMI Ubuntu 24.04"
  default     = "ami-04ec97dc75ac850b1"
  type        = string
}

variable "public_key_path" {
  description = "Chemin vers la clé publique"
  default     = "~/.ssh/iia-2025.pub"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC dans lequel déployer les ressources"
  default     = "vpc-03480d50e3190e317"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR du subnet privé"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_az" {
  description = "Availability Zone pour le subnet privé (ex: eu-west-3a)"
  default     = "eu-west-3a"
  type        = string
}
