#!/usr/bin/env bash

cat /etc/conf.d/*.py > "${INVENIO_INSTANCE_PATH}/invenio.cfg"
