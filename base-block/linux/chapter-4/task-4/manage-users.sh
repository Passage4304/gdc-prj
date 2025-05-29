#!/bin/bash

CREATE_FILE="users-for-creation.csv"
DELETE_FILE="users-for-deletion.csv"
LOGFILE="$(pwd)/logs/logfile.log"
DELETE_MODE=false

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOGFILE"
}

generate_password() {
    openssl rand -base64 12
}

create_users() {
    if [[ ! -f "$CREATE_FILE" ]]; then
        echo "Файл $CREATE_FILE не найден"
        exit 1
    fi

    tail -n +2 "$CREATE_FILE" | while IFS=',' read -r username role; do
        if id "$username" &>/dev/null; then
            log "Пользователь $username уже существует. Пропущен."
            continue
        fi

        # Создание пользователя и группы
        useradd -m -s /bin/bash -G "$role" "$username" 2>>"$LOGFILE"
        if [[ $? -ne 0 ]]; then
            log "Ошибка создания пользователя $username"
            continue
        fi

        # Пароль
        password=$(generate_password)
        echo "$username:$password" | chpasswd
        log "Пользователь $username создан с паролем: $password"

        # Права на домашнюю директорию
        chown -R "$username:$username" "/home/$username"

        # SSH ключи
        su - "$username" -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
        ssh-keygen -t rsa -b 2048 -f "/home/$username/.ssh/id_rsa" -q -N ""
        chown -R "$username:$username" "/home/$username/.ssh"
        log "SSH ключи созданы для $username"
    done
}

delete_users() {
    if [[ ! -f "$DELETE_FILE" ]]; then
        echo "Файл $DELETE_FILE не найден"
        exit 1
    fi

    tail -n +2 "$DELETE_FILE" | while IFS=',' read -r username delete_home; do
        if ! id "$username" &>/dev/null; then
            log "Пользователь $username не существует. Пропущен."
            continue
        fi

        if [[ "$delete_home" == "true" ]]; then
            userdel -r "$username" 2>>"$LOGFILE"
            log "Пользователь $username и домашняя директория удалены."
        else
            userdel "$username" 2>>"$LOGFILE"
            log "Пользователь $username удалён (домашняя директория сохранена)."
        fi
    done
}

case "$1" in
    create)
        create_users
        ;;
    delete)
        delete_users
        ;;
    *)
        echo "Использование: $0 {create|delete}"
        exit 1
        ;;
esac
