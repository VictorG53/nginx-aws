# Projet Urbanisation du SI

Ce projet permet de lancer une instance EC2 sur AWS avec Terraform et d’installer automatiquement Nginx sur cette instance.

## Prérequis

- [Terraform](https://www.terraform.io/)
- [Ansible](https://docs.ansible.com/)
- Un fichier `.env` contenant les variables nécessaires (voir `.env.example`)

## Utilisation

1. Copier le fichier `.env.example` en `.env` et renseigner les variables requises.
2. Exécuter le script suivant pour tout déployer :

Windows :
```bash
./start.sh
```

Macos :
```bash
sh start.sh
```

Ce script initialise Terraform, applique la configuration et installe Nginx sur l’instance EC2 créée.

## Structure

- `main.tf` : Configuration Terraform pour AWS EC2
- `install_nginx.sh` : Script d’installation de Nginx sur l’instance
- `start.sh` : Script d’automatisation du déploiement