#!/usr/bin/env bash

set -e

. /usr/lib/wait-for-services.sh

# Wait for DB to be ready
if ! check_ready "DB" db_check ; then exit 1; fi

printf "\n* Connected to DB!"

if [ "$DEPLOY" = "True" ]; then
  # Check if DB is already initialized and healthy
  echo "> Initializing DB..."
  health=$(invenio heartbeat liveliness db)
  if [ "$health" = "healthy" ]; then
    echo "- Nothing to do. DB already created."
    exit 0
  else
    invenio db init create
  fi
fi
