import pprint

from flask import current_app, url_for, redirect
from oarepo_heartbeat.views import readiness, liveliness
from invenio_app.wsgi_rest import application


class Middleware:
    """
    HeartBeat enabled WSGI middleware
    """

    def __init__(self, app):
        self.app = app

    def __call__(self, environ, start_response):
        print('Environment variables:')
        pprint.pprint(dict(environ), width=1)
        rsp = None
        with application.app_context():
            pi = environ.get('PATH_INFO', '')
            if pi == '/.well-known/heartbeat/readiness':
                print(current_app, url_for('oarepo-heartbeat.readiness'))
                rsp = readiness()
            elif pi == '/.well-known/heartbeat/liveliness':
                print(current_app, url_for('oarepo-heartbeat.liveliness'))
                rsp = liveliness()
            if rsp:
                return rsp(environ, start_response)
            else:
                return self.app(environ, start_response)


application.wsgi_app = Middleware(application.wsgi_app)
