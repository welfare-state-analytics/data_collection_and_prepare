from pydoc import doc
from sqlite3.dbapi2 import NotSupportedError

import pytest
from data_collection import __version__
from data_collection.riksdagens_open_data.rdo_client import RODClient, RODQuery


def test_version():
    assert __version__ == '0.1.0'


def test_rod_client_catalog():

    client = RODClient()

    response = client.find()

    assert response is not None
    assert response.status_code == 200


def test_find_call_with_prot_argument_succeeds():

    client = RODClient()

    query_result = client.find(doktyp='prot')

    assert query_result is not None
    assert len(list(query_result)) > 0


def test_find_documents_with_prot_argument_succeeds():

    client = RODClient()

    criterias = {'doktyp': 'prot', 'from': '2001-02-01', 'tom': '2001-12-31'}

    query_result = client.find(**criterias)
    n_expected_documents = int(query_result['@traffar'])

    documents = client.find_documents(**criterias)

    n_documents = 0
    with pytest.raises(StopIteration):
        while True:
            _ = next(documents)
            n_documents += 1

    assert n_documents == n_expected_documents


def test_store_documents():

    client = RODClient()

    criterias = {'doktyp': 'prot', 'from': '2001-02-01', 'tom': '2001-12-31'}

    documents = [x for x in client.find_documents(**criterias)]

    import json

    with open('pro.documents.json', 'w') as fp:
        json.dump(documents, fp)


def test_create_query_with_doktype_specified():

    q = RODQuery(doktyp='kalle')
    url = q.get_url()
    assert 'doktyp=kalle' in url


def test_create_query_with_empty_doktyp_value_succeeds():

    q = RODQuery()
    url = q.get_url()
    assert 'doktyp=&' in url


def test_create_query_with_utformat_is_not_json():

    with pytest.raises(NotSupportedError):
        _ = RODQuery(utformat='xml')


def test_create_query_with_no_arguments_should_still_have_all_attributes():

    q = RODQuery()
    url = q.get_url()

    assert all((k in url for k in q.default_criterias.keys()))
