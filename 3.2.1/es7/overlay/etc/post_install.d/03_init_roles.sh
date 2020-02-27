#!/usr/bin/env bash

set -e

if [ "$DEPLOY" = "True" ]; then
  printf "\n* Creating administrative user"

  # Check if admin is not created yet
  admrole=$(invenio shell --no-term-title /usr/lib/check_admin_role.py)
  if [ "$admrole" = "present" ]; then
    echo "- Nothing to do. Admin role is already created."
    exit 0
  fi

  # Create admin role
  printf "\n> Creating admin role..."
  invenio roles create admin
  invenio access allow superuser-access role admin

  # Create admin user
  echo "> Creating admin user: ${OAREPO_ADMIN_USER}"
  invenio users create -a --password "${OAREPO_ADMIN_PASSWORD}" "${OAREPO_ADMIN_USER}"
  invenio access allow superuser-access user "${OAREPO_ADMIN_USER}"
fi
