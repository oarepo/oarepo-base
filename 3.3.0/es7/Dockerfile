# -*- coding: utf-8 -*-
#
# Copyright (C) 2020 CESNET.
#
# OARepo Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#
# Base Dockerfile image for oarepo site application.
#
# This image installs all Python dependencies for your OArepo application. It's based
# on CentOS 7 with Python 3 (https://github.com/inveniosoftware/docker-invenio)
# and includes Pip, Node.js, NPM and some few standard libraries
# Invenio and OARepo sites usually needs.
FROM inveniosoftware/centos8-python:3.8

ARG OAREPO_VERSION=3.3.0

LABEL maintainer="CESNET <bauer@cesnet.cz>" \
  org.label-schema.name="OpenAccess repository site" \
  org.label-schema.vendor="CESNET" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/oarepo/oarepo-base" \
  org.label-schema.version="$OAREPO_VERSION"

RUN pip install pip-tools

# Install oarepo deployment requirements
COPY ./requirements.d /etc/requirements.d/
RUN cat /etc/requirements.d/*.in | pip-compile -U -o .requirements.txt -
RUN pip install -r .requirements.txt

# Collect and build invenio assets
USER invenio
RUN invenio collect -v  && \
    invenio webpack create && \
    invenio webpack install && \
    invenio webpack buildall

EXPOSE 5001

COPY ./overlay /

ENTRYPOINT [ "/usr/bin/entrypoint" ]

USER root
RUN chown invenio /usr/bin/entrypoint && chmod u+x /usr/bin/entrypoint
USER invenio
