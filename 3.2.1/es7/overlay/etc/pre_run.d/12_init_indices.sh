#!/usr/bin/env bash

set -e

. /usr/lib/wait-for-services.sh

# Wait for ES to be ready
if ! check_ready "ElasticSearch" es_check ; then exit 1; fi

health=$(invenio heartbeat liveliness es)
[[ "$health" != "healthy" ]] && exit 1

printf "\n* Connected to ElasticSearch!"

if [ "$DEPLOY" = "True" ]; then
  echo "> Initializing ES indices..."

  # Check if ES has already indices created and is healthy
  indicnt=$(curl -sS http://es:9200/_cat/indices | wc -l)
  if [ $indicnt -gt 0 ]; then
    echo "- Nothing to do. Indices already created."
    exit 0
  fi

  invenio index init --force
  invenio index queue init purge
fi
