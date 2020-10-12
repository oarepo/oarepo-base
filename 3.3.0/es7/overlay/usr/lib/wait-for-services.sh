#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2020 CESNET.
#
# Invenio Site is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

# Verify that all services are running before continuing
check_ready() {
    RETRIES=10
    while ! $2
    do
        echo "Waiting for $1, $((RETRIES--)) remaining attempts..."
        sleep 2
        if [ $RETRIES -eq 0 ]
        then
            echo "Couldn't reach $1"
            exit 1
        fi
    done
}

_heartbeat_check(){
  res=$(invenio heartbeat readiness "$1")
  [[ "$res" = "ready" ]] && return 0
  return 1
}

db_check(){
  _heartbeat_check db
}

es_check(){
  _heartbeat_check es
}

redis_check(){
  _heartbeat_check redis
}

rabbit_check(){ docker-compose exec mq bash -c "rabbitmqctl status" &>/dev/null; }

if [ "$1" == "--full" ]
then
    check_ready "Postgres" db_check
    check_ready "Elasticsearch" es_check
    check_ready "Redis" redis_check
    check_ready "RabbitMQ" rabbit_check

#    _web_server_check_http(){ curl --output /dev/null --silent --head --fail http://localhost:80 &>/dev/null; }
#    check_ready "Web Server HTTP" _web_server_check_http
fi
