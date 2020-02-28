INVENIO_EXPLICIT_ACLS_SCHEMA_TO_INDEX = 'invenio_explicit_acls.utils.default_schema_to_index_returning_doc'
INDEXER_RECORD_TO_INDEX = 'invenio_explicit_acls.utils.default_record_to_index_returning_doc'
SEARCH_ELASTIC_HOSTS = [dict(host=h) for h in os.getenv('INVENIO_SEARCH_ELASTIC_HOSTS', 'localhost').split(',')]
