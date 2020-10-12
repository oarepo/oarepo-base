#!/usr/bin/env python

from invenio_accounts.models import Role

roles = [r.name for r in Role.query.all()]
if 'admin' in roles:
    print('present')
else:
    print('missing')
