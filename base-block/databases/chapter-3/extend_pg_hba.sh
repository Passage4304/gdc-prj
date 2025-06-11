#!/bin/bash

PG_HBA="$PGDATA/pg_hba.conf"
APPEND_FILE="/pg_hba.append.conf"

# Подождать, пока инициализируется папка данных
while [ ! -f "$PG_HBA" ]; do
  sleep 1
done

# Добавим строку, если её ещё нет
if ! grep -q "repl_user" "$PG_HBA"; then
  echo ">> Adding replication access to pg_hba.conf"
  cat "$APPEND_FILE" >> "$PG_HBA"
fi

exec docker-entrypoint.sh postgres