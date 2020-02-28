APP_ALLOWED_HOSTS = [h for h in os.getenv('APP_ALLOWED_HOSTS', '').split(',')]
APP_DEFAULT_SECURE_HEADERS = {
    'content_security_policy': {
#      'default-src': [
#          '\'self\'',
#      ],
      'script-src': [
          '\'sha256-eWKugvnGzWDg1/cLEtGsYUa2Gmocx1sNVm/kWiIxkC0=\'',
      ]
    }
}
