#!/bin/bash

# === ПАРАМЕТРЫ ===
CPU_LOAD=4          # Количество процессов для нагрузки на CPU
MEM_LOAD_MB=1024    # Объем памяти (в МБ), которую нужно занять
DISK_LOAD_MB=500    # Объем данных для записи на диск
DURATION=60         # Время выполнения теста в секундах
TMP_DIR="/tmp/stress_test"

# === ПОДГОТОВКА ===
mkdir -p "$TMP_DIR"
echo "[*] Старт стресс-теста на $DURATION секунд..."

# === Нагрузка на CPU ===
echo "[*] Нагрузка на CPU (количесво потоков = $CPU_LOAD)"
for i in $(seq 1 "$CPU_LOAD"); do
    sha1sum /dev/zero &
done

# === Нагрузка на память ===
echo "[*] Нагрузка на память ($MEM_LOAD_MB MB)"
MEM_LOAD_KB=$((MEM_LOAD_MB * 1024))
dd if=/dev/zero of=/dev/null bs=1K count="$MEM_LOAD_KB" &
python3 -c "a = ' ' * $((MEM_LOAD_MB * 1024 * 1024)); import time; time.sleep($DURATION)" &

# === Нагрузка на диск ===
echo "[*] Нагрузка на диск ($DISK_LOAD_MB MB)"
dd if=/dev/urandom of="$TMP_DIR/testfile1" bs=1M count="$DISK_LOAD_MB" oflag=direct &
dd if="$TMP_DIR/testfile1" of="$TMP_DIR/testfile2" bs=1M oflag=direct &

# === Ожидание завершения ===
sleep "$DURATION"
echo "[*] Завершение стресс-теста"

# === Очистка ===
killall sha1sum dd python3 2>/dev/null
rm -rf "$TMP_DIR"

echo "[*] Готово"
