#!/bin/bash

#Проверяем на root
if [ "$EUID" -ne 0 ]; then
  echo "Ошибка: Запустите скрипт от имени root (sudo ./install.sh)"
  exit 1
fi

echo "PROD VDS INSTALLER"

#Базовые пакеты(ставятся всегда)
echo "[+] Установка базовых утилит(htop, git и т.д.)"
apt update -y && apt install -y curl wget htop git tmux ufw fail2ban

#Интерактивный выбор(опционально)
echo ""
echo "Что еще установить? (y/n)"
read -p "Python?" INSTALL_PYTHON
read -p "Docker?" INSTALL_DOCKER
read -p "Nginx (reverse proxy)?" INSTALL_NGINX
read -p "PostgreSQL?" INSTALL_POSTGRES

#Установка Python
if [ "$INSTALL_PYTHON" = "y" ]; then
    echo "[+] Устанавливаем Python.."
    apt install -y python3 python3-pip python3-venv
fi

#Установка Docker
if [ "$INSTALL_DOCKER" = "y" ]; then
    echo "[+] Устанавливаем Docker.."
    curl -fsSL https://get.docker.com | sh
fi

#Установка Nginx
if [ "$INSTALL_NGINX" = "y" ]; then
    echo "[+] Устанавливаем Nginx.."
    apt install -y nginx
fi

#Устаовка PostgreSQL
if [ "$INSTALL_POSTGRES" = "y" ]; then
    echo "[+] Устанавливаем PostgreSQL.."
    apt install -y postgresql
fi

# Настройка безопасности, надстройка над iptables (UFW)
echo ""
echo "[+] Настройка UFW.."
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo ""
echo "Установка завершена"
echo "Проверьте статус слкжбы: systemctl status nginx docker"





