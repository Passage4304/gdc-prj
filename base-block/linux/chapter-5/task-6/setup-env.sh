#!/bin/bash

set -e

### --- Определение ОС и пакетного менеджера ---
echo "[1] Определяем ОС..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Не удалось определить ОС"
    exit 1
fi

echo "Обнаружена ОС: $OS"

# Определение пакетного менеджера
case "$OS" in
    ubuntu|debian)
        PM="apt"
        INSTALL="apt install -y"
        UPDATE="apt update"
        FIREWALL_CMD="ufw"
        ;;
    centos|rhel)
        PM="yum"
        INSTALL="yum install -y"
        UPDATE="yum update -y"
        FIREWALL_CMD="firewalld"
        ;;
    fedora)
        PM="dnf"
        INSTALL="dnf install -y"
        UPDATE="dnf update -y"
        FIREWALL_CMD="firewalld"
        ;;
    opensuse*|sles)
        PM="zypper"
        INSTALL="zypper install -y"
        UPDATE="zypper refresh"
        FIREWALL_CMD="firewalld"
        ;;
    arch)
        PM="pacman"
        INSTALL="pacman -S --noconfirm"
        UPDATE="pacman -Sy"
        FIREWALL_CMD="ufw"
        ;;
    *)
        echo "ОС $OS не поддерживается этим скриптом"
        exit 1
        ;;
esac

### --- Установка пакетов ---
echo "[2] Обновляем систему и устанавливаем пакеты..."

sudo $UPDATE
sudo $INSTALL nginx php php-mysql mysql-server curl

### --- Запуск и включение сервисов ---
echo "[3] Запускаем и включаем сервисы..."

for svc in nginx mysql; do
    sudo systemctl enable $svc
    sudo systemctl start $svc
done

### --- Настройка MySQL ---
echo "[4] Настраиваем базу данных..."

DB_NAME="testdb"
DB_USER="testuser"
DB_PASS="testpass"

sudo mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
sudo mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "База данных $DB_NAME создана с пользователем $DB_USER."

### --- Настройка фаервола ---
echo "[5] Настраиваем фаервол..."

if [ "$FIREWALL_CMD" = "ufw" ]; then
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    sudo ufw --force enable
elif [ "$FIREWALL_CMD" = "firewalld" ]; then
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --permanent --add-service=ssh
    sudo firewall-cmd --reload
else
    echo "Неизвестная система фаервола, настройка пропущена"
fi

echo "✅ Настройка завершена. Сервер работает, база $DB_NAME создана."