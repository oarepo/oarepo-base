#!/usr/bin/env bash

set -e

. /usr/lib/wait-for-services.sh

# Wait for Redis to be ready
if ! check_ready "Redis" redis_check ; then exit 1; fi

printf "\n* Connected to Redis!"

if [ "$DEPLOY" = "True" ]; then
  echo "> Clearing the Redis Cache..."
  invenio shell --no-term-title -c "import redis; redis.StrictRedis.from_url(app.config['CACHE_REDIS_URL']).flushall(); print('Cache cleared')"
fi
