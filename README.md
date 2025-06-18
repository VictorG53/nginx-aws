# Projet Urbanisation du SI

Ce projet permet de lancer une instance EC2 sur AWS avec Terraform et d’installer automatiquement Nginx sur cette instance.

## Prérequis

- [Terraform](https://www.terraform.io/)
- [Ansible](https://docs.ansible.com/)
- Un fichier `.env` contenant les variables nécessaires (voir `.env.example`)

## Utilisation

Le déploiement du projet est désormais automatisé via le pipeline CI/CD GitHub Actions.  
Il suffit de pousser vos modifications sur le dépôt GitHub pour déclencher le déploiement : le pipeline initialise Terraform, applique la configuration et installe Nginx sur l’instance EC2 créée.

## Structure

- `main.tf` : Configuration Terraform pour AWS EC2
- `install_nginx.sh` : Script d’installation de Nginx sur l’instance
- `start.sh` : Ancien script d’automatisation du déploiement (remplacé par le pipeline CI/CD)
