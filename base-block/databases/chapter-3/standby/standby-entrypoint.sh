#!/bin/bash
set -e

# Ждём, пока primary будет доступен
until pg_basebackup -h primary -D "$PGDATA" -U repl_user -Fp -Xs -P -R; do
  echo "Waiting for primary to become available..."
  sleep 2
done

# Передаём управление стандартному entrypoint PostgreSQL
exec docker-entrypoint.sh postgres