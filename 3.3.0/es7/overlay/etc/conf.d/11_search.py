SEARCH_ELASTIC_HOSTS = [dict(host=h) for h in os.getenv('INVENIO_SEARCH_ELASTIC_HOSTS', 'localhost').split(',')]
