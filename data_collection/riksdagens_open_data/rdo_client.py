from sqlite3.dbapi2 import NotSupportedError
import requests

import logging

logger = logging.getLogger('RODClient')
logger.setLevel(level=logging.DEBUG)

class RODQuery():

    def __init__(self, **kwargs):

        self.find_url = "http://data.riksdagen.se/dokumentlista/?sok=&{}&a=s#soktraff"

        self.default_criterias = {
            "doktyp": "",
            "from": "",
            "tom": "",
            "ts": "",
            "bet": "",
            "tempbet": "",
            "nr": "",
            "org": "",
            "iid": "",
            "webbtv": "",
            "talare": "",
            "exakt": "",
            "planering": "",
            "sort": "rel",
            "sortorder": "desc",
            "rapport": "",
            "utformat": "json"
        }

        self.arguments = { **self.default_criterias, **kwargs }

        if self.arguments['utformat'] != 'json':
            raise NotSupportedError("This client only support JSON responses!")

    def get_url(self):

        return self.find_url.format(
            '&'.join([ "{}={}".format(k, self.arguments[k]) for k in self.arguments.keys() ])
        )

class RODClient():

    def __init__(self, **kwargs):

        self.find_url = "http://data.riksdagen.se/dokumentlista/?sok=&utformat={format}&a=s#soktraff"

        self.default_criterias = {
            "doktyp": "",
            "from": "",
            "tom": "",
            "ts": "",
            "bet": "",
            "tempbet": "",
            "nr": "",
            "org": "",
            "iid": "",
            "webbtv": "",
            "talare": "",
            "exakt": "",
            "planering": "",
            "sort": "rel",
            "sortorder": "desc",
            "rapport": "",
            "utformat": "json"
        }

    def _find_by_url(self, url):

        response = requests.get(url)

        if response.status_code == 200:

            if 'json' in response.headers['content-type']:
                data = response.json()

            #if 'xml' in response.headers['content-type']:
            #    data = xmltodict.parse(response.body())

                if 'dokumentlista' not in data:
                    raise NotSupportedError("Expected key 'dokumentlista' not found!")

                return data['dokumentlista']

        response.raise_for_status()

    def find(self, **criterias):

        query = RODQuery(**criterias)

        return self._find_by_url(query.get_url())

    def find_documents(self, **criterias):

        logger.debug('Entering find_documents')

        query_result = self.find(**criterias)
        n_expected_documents = query_result['@traffar']
        n_documents = 0

        while True:

            for document in query_result['dokument']:

                logger.debug(f"Yielding {document['dok_id']}")
                n_documents += 1

                yield document

            next_url = query_result.get('@nasta_sida', '')

            if next_url == '':
                break

            logger.debug('Retrieving next page...')

            query_result = self._find_by_url(next_url)

        if n_documents != int(n_expected_documents):
            logger.warning(f"Number of expected documents {n_expected_documents} differs from actual count {n_documents}")

        logger.debug('Execting find_documents')

#     def download(self, document, type='text', target=None):

#         key = {
#             "text": "dokument_url_text",
#             "html": "dokument_url_html"
#         }

#         response = requests.get(url)

# #        if response.status_code == 200:
