#!/bin/bash
export $(grep -v '^#' .env | xargs)

# Initialisation de Terraform et application de la configuration
terraform -chdir=./terraform init
terraform -chdir=./terraform fmt
terraform import aws_security_group.ec2_eg sg-017427007c0a619f7
terraform -chdir=./terraform apply -auto-approve

# Récupération de l'adresse IP de l'instance
INSTANCE_IP=$(terraform -chdir=./terraform output -raw instance_ip)

# Ajout de l'IP de l'instance à known_hosts
ssh-keygen -R $INSTANCE_IP
until ssh-keyscan -H $INSTANCE_IP >> ~/.ssh/known_hosts 2>/dev/null; do
  echo \"En attente que l’instance soit prête...\"
  sleep 2
done

# Création d'un inventaire temporaire pour Ansible
echo "$INSTANCE_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/iia-2025.pem" > hosts

# Lancement du playbook Ansible
ansible-playbook -i hosts ./ansible/install_nginx.yml