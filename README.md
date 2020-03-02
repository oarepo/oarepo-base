# oarepo-base
[![Build Status](https://travis-ci.org/oarepo/oarepo-base.svg?branch=master)](https://travis-ci.org/oarepo/oarepo-base) [![image](https://img.shields.io/docker/automated/oarepo/oarepo-base.svg)](https://hub.docker.com/r/oarepo/oarepo-base/) [![image](https://img.shields.io/docker/build/oarepo/oarepo-base.svg)](https://hub.docker.com/r/oarepo/oarepo-base/builds/)

Base Docker image for building and running OArepo instances.

This image serves as base image for [OA repository](https://github.com/oarepo) instances based on [Invenio](https://github.com/inveniosoftware/invenio). The purpose is to provide a base image that is usable in production environments like OpenShift or Kubernetes.

The image is based on the official Invenio Docker image ``inveniosoftware/centos7-python:3.6`` and contains:

- Python 3.6 set as default Python interpreter with upgraded versions of pip, pipenv, setuptools and wheel.
- Tools: Node.js, NPM, Git, Curl Vim, Emacs, Development Tools.
- Library devel packages: libffi, libxml2, libxslt.
- Working directory for an Invenio instance.
- Basic Invenio installation with ES7 support
- Common OARepo modules:
    * `heartbeat` for instance health and readiness checks
    * `acls` for explicit acl management support
    * `files` for files management and rest APIs
    * `models` for basic DC data models with marshmallow
    * `includes` for composable ES mappings support
    * `ui` for API endpoints for UI clients

## Versioning

This image follows the versioning of Invenio.

## Supported tags and respective ``Dockerfile`` links

* 3.2.1-es7 - [Dockerfile](https://github.com/oarepo/oarepo-base/blob/master/3.2.1/es7/Dockerfile).

### Environment variables

The following environment variables are available by default (see [.env-example](https://github.com/oarepo/oarepo-base/blob/master/.env-example)):

- ``OAREPO_VERSION=3.2.1``
- ``OAREPO_ES_VERSION=es7``
- ``WORKING_DIR=/opt/invenio``
- ``INVENIO_INSTANCE_PATH=/opt/invenio/var/instance``
- ``INVENIO_USER_ID=1000``
- ``APP_ALLOWED_HOSTS``
- ``APP_ENABLE_SECURE_HEADERS``
- ``SERVER_NAME``
- ``OAREPO_ADMIN_PASSWORD``
- ``OAREPO_ADMIN_USER``
- ``JSONSCHEMAS_HOST``
- ``INVENIO_SQLALCHEMY_DATABASE_URI``
- ``INVENIO_BROKER_URL``
- ``INVENIO_CELERY_BROKER_URL``
- ``INVENIO_CELERY_RESULT_BACKEND``
- ``INVENIO_CACHE_TYPE``
- ``INVENIO_CACHE_REDIS_URL``
- ``INVENIO_ACCOUNTS_SESSION_REDIS_URL``
- ``INVENIO_RATELIMIT_STORAGE_URL``
- ``INVENIO_SEARCH_ELASTIC_HOSTS``
- ``SEARCH_INDEX_PREFIX``

To use them in the `docker-compose` files, feel free to copy over and modify the `.env-example` to the `.env` file.
Any additional environment variables that are supported by Invenio can be added to your environment.

## Usage

### Deployment

To deploy the OArepo instance for a first time on your infrastructure, run the
image with the `deploy` command within a correct environment:

```
docker run oarepo-base deploy
```

This will prepare the database tables for Invenio, initialize ElasticSearch indices and
message queues.

### Quickstart

To quickly try things out in a local environment the following compose files are prepared:

```
docker-compose -f docker-compose.deploy.yml up --abort-on-container-exit
```
Runs the basic Invenio infrastracture and executes the OArepo deployment scripts on it.

```
docker-compose -f docker-compose.yml up -d
```
After OArepo is deployed, you can use this to run the instance with just a minimal set of services.

```
docker-compose -f docker-compose.full.yml up -d
```
Spins up a full production-like infrastructure for OArepo. 

## Customization

In order to create your own OArepo flavours, this base image can be customized in many ways:

### Dockerfile

Replicate the following overlay folder structure within your project:
```
├── Dockerfile
├── overlay
│   ├── etc
│   │   ├── conf.d
│   │   ├── pre_run.d
│   │   ├── requirements.d
```

Then base your Dockerfile on this image:
```
FROM oarepo/oarepo-base:3.2.1-es7
```

### Python Requirements

To add more requirements for your project, create a requirements file in the `requirements.d` directory and
place your requirements in it:
```
│   │   ├── requirements.d
|   |   |   ├── myproject-requirements.in
```

Then edit your `Dockerfile` to compile and install your requirements:
```
RUN cat /etc/requirements.d/*.in | pip-compile -U -o .requirements.txt -
RUN pip install -r .requirements.txt
```
_Note: this way, the requirement compilation process takes into account all pre-existing requirements that
may be in the folder together with yours._

Once your done editing/adding files in your overlay (see below), copy in the overlay
in your `Dockerfile`:
```
COPY ./overlay /
```

### Pre-Run hooks

The scripts in the `etc/pre_run.d` directory are being run by the entrypoint just before the `uwsgi` Invneio app
is executed. You can add more hooks to the folder or overwrite the existing ones by
giving them the same name.

### Pythonic Configuration

If you require more complex configuration that cannot be passed via environment
variables (e.g. Python variables), you can add your configuration snippets
to the `etc/conf.d` directory.

The `etc/pre_run.d/05_init_config.sh` pre-run hook compiles the final `invenio.cfg`
config file from all the files present in the `etc/conf.d` directory.


## License

Copyright (C) 2020 CESNET.

OARepo Docker is free software; you can redistribute it and/or modify it
under the terms of the MIT License; see LICENSE file for more details.