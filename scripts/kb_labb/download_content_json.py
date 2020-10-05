import os
import sys

import click
import dotenv

root_folder = (lambda x: os.path.join(os.getcwd().split(x)[0], x))('westac_data')

sys.path = list(set(sys.path + [ root_folder ]))

import src.kb_labb.download as download
# pylint: disable=no-value-for-parameter

@click.command()
@click.argument('tag', )
@click.argument('target_filename', )
@click.option('--year', default=None, type=click.INT)
def download_tag_content_json(tag, target_filename, year=None):

    dotenv.load_dotenv(dotenv_path=os.path.join(os.environ['HOME'], '.vault/.kblab.env'))

    query = { "tags": tag }

    max_count = None

    excludes = [ "*.jpg", "*.jb2e", "*.xml", "coverage.*", "structure.json" ]
    includes = [ "content.json", "meta.json" ]

    if year is not None:

        #for year in range(year_range[0], year_range[1] + 1):

        query["meta.created"] = str(year)

        download.download_query_to_zip(query, max_count, target_filename, includes=includes, excludes=excludes, append=True)

    else:

        download.download_query_to_zip(query, max_count, target_filename, includes=includes, excludes=excludes, append=True)

if __name__ == "__main__":

    download_tag_content_json()
