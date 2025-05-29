#!/bin/bash

# === НАСТРОЙКИ ===
SRC_DIR="/home/artem/git/hub/gdc-prj/base-block/linux/chapter-4/task-2/very-important-dir"                # Что архивируем
BACKUP_DIR="/mnt/data-hard-1TB/Backups/learning/very-important-dir"          # Куда сохраняем
SNAPSHOT_FILE="$BACKUP_DIR/snapshot.snar"
LOG_FILE="$(pwd)/logs/script-backup.log"
CHECKSUM_FILE="$(pwd)/checksums.sha256"

# === ФУНКЦИЯ: Лог ===
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# === ФУНКЦИЯ: Архивирование ===
backup() {
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"
    ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

    mkdir -p "$BACKUP_DIR"

    # Выполняем архивирование
    if tar --listed-incremental="$SNAPSHOT_FILE" -czf "$ARCHIVE_PATH" "$SRC_DIR" 2>>"$LOG_FILE"; then
        echo "$(sha256sum "$ARCHIVE_PATH")" >> "$CHECKSUM_FILE"
        log "[+] Бэкап успешно создан: $ARCHIVE_NAME"
    else
        echo "[!] Ошибка при создании бэкапа" >&2
        log "[!] Ошибка при создании бэкапа: $ARCHIVE_NAME"
        exit 1
    fi
}

# === ФУНКЦИЯ: Восстановление ===
restore() {
    echo "[*] Доступные архивы:"
    ls -1 "$BACKUP_DIR"/backup_*.tar.gz

    read -p "Введите имя архива для восстановления (например: backup_2025-05-29_12-00-00.tar.gz): " ARCHIVE_NAME
    ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"
    read -p "Куда восстановить данные (абсолютный путь): " RESTORE_DIR

    if [[ ! -f "$ARCHIVE_PATH" ]]; then
        echo "[!] Архив не найден!" >&2
        exit 1
    fi

    # Проверка контрольной суммы
    if ! sha256sum -c "$CHECKSUM_FILE" --status --quiet <<< "$(grep "$ARCHIVE_NAME" "$CHECKSUM_FILE")"; then
        echo "[!] Контрольная сумма не совпадает! Архив повреждён." >&2
        log "[!] Повреждён архив $ARCHIVE_NAME — не совпадает sha256"
        exit 1
    fi

    mkdir -p "$RESTORE_DIR"

    # Определим, сколько компонентов удалить (посчитаем папки в SRC_DIR)
    STRIP_COUNT=$(echo "$SRC_DIR" | tr '/' '\n' | grep -v '^$' | wc -l)

    # Восстановление с удалением промежуточных директорий
    if tar --listed-incremental=/dev/null -xzf "$ARCHIVE_PATH" -C "$RESTORE_DIR" --strip-components="$STRIP_COUNT" 2>>"$LOG_FILE"; then
        log "[+] Успешное восстановление из $ARCHIVE_NAME в $RESTORE_DIR"
    else
        echo "[!] Ошибка восстановления архива" >&2
        log "[!] Ошибка восстановления $ARCHIVE_NAME"
        exit 1
    fi
}

# === ИНТЕРФЕЙС ===
case "$1" in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
    *)
        echo "Использование: $0 {backup|restore}"
        ;;
esac
