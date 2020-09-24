#%%
import pandas as pd
import zipfile
import numpy as np
import io
import os
from os.path import join as jj

def read_document_index(zip_filename):
    df_total = None
    with zipfile.ZipFile(zip_filename, mode="r") as zip_file:
        for filename in zip_file.namelist():
            with zip_file.open(filename, "r") as f:
                data = f.read().decode('UTF-8')
                data = data.replace('"""', '""').replace("﻿", "")
                df = pd.read_csv(io.StringIO(data), header=None, delimiter=",", quotechar='"')
                df_total = df if df_total is None else df_total.append(df, ignore_index=True)
    df_total.columns = [
        "hangar_id", "dok_id", "riksdag_session", "beteckning", "doktyp", "typ", "subtyp", "tempbeteckning", "organ", "mottagare", "nummer", "datum", "systemdatum", "titel", "subtitel", "status", "relaterat_id"
    ]
    df_total.at[df_total.dok_id=="G209106", "nummer"] = 106

    df_total['year'] = df_total.riksdag_session.apply(lambda x: int(x.split('/')[0]))
    return df_total.set_index('dok_id')

def rename_files(source_filename, target_filename, document_index):

    #p = re.compile(r"^(?P<session_id>[A-Z0-9]{2})(?P<doc_type_id>[A-Z0-9]{2})(?P<sequence_id>[0-9]{1,})\.*")

    with zipfile.ZipFile(target_filename, mode="w", compresslevel=zipfile.ZIP_DEFLATED) as tf:
        with zipfile.ZipFile(source_filename, mode="r") as sf:

            source_names = sf.namelist()

            # List files that don't exist in source zip
            print("Checking for missing files...")
            for basename, _ in (os.path.splitext(filename) for filename in source_names):
                # files basename if the document id
                if not any(document_index.index.str.contains(basename.upper())):
                    print(f"missing document: {basename}")

            print("Creating new archive with renamed files...")
            for source_name in source_names:
                data = sf.read(source_name).decode('UTF-8')
                dokument_id, _ = os.path.splitext(source_name)
                metadata = document_index.loc[dokument_id.upper()].to_dict()
                target_name = f"prot_{metadata['riksdag_session'].replace('/', '')}__{metadata['beteckning']}.txt"
                tf.writestr(target_name, data,)
            print("Done!")
# %%
def prepare_riksdagens_protokoll_from_riksdagens_open_data(data_folder):
    """creates a compiled document index (CSV) and a text corpus (ZIP) for all text files 1971-2020 (downloaded September 24th)
    """
    downloaded_text_filename = jj(data_folder, 'prot-1971-2021.text.zip')
    downloaded_csv_filename = jj(data_folder, 'prot-1971-2021.csv.zip')

    target_corpus_filename = jj(data_folder, 'prot-1971-2021.riksdagens.open.data.text.zip')
    target_document_index_filename = jj(data_folder, 'prot-1971-2021.riksdagens.open.data.document_index.csv')

    # serie_codes = pd.read_csv(jj(data_folder, 'document_serie_codes.csv'), header=0, sep=",", quotechar='"', dtype={}).set_index('code')
    # session_codes = pd.read_csv(jj(data_folder, 'riksdag_session_codes.csv'), header=0, sep=',', quotechar='"', dtype={'year': np.int32}).set_index('riksdag_session_id')

    if not os.path.isfile(target_document_index_filename):
        document_index = read_document_index(downloaded_csv_filename)
        document_index.to_csv(target_document_index_filename, sep='\t')
    else:
        document_index = pd.read_csv(target_document_index_filename, sep='\t', header=0).set_index('dok_id')

    rename_files(downloaded_text_filename, target_corpus_filename, document_index)

prepare_riksdagens_protokoll_from_riksdagens_open_data(data_folder="~/source/welfare-state-analytics/data")