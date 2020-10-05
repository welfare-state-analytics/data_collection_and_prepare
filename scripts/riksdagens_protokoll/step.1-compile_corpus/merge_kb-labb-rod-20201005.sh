#!/bin/sh

ZDIR=~/source/welfare-state-analytics/data/riksdagens_protokoll
# This script merges Riksdagens protokoll downloaded from KB-labb and Riksdagens öppna data
# The merges is done as:
#  1. Copy KB-labb file
#  2. Delete years of no interest from KB-lab file
#  3. Merge new KB-labb file with 1990-2020 RÖD file

cd ${ZDIR}/kb_labb

# Ta en kopia och ta bort 1800-talet, (19)00-talet och 1910-talet
rm -f riksdagens_protokoll_kb-labb_1920-1989.zip
cp -f riksdagens_protokoll_kb_labb_text_202000930.zip riksdagens_protokoll_kb-labb_1920-1989.zip

zip -d riksdagens_protokoll_kb-labb_1920-1989.zip "prot_18*.*"
zip -d riksdagens_protokoll_kb-labb_1920-1989.zip "prot_190*.*"
zip -d riksdagens_protokoll_kb-labb_1920-1989.zip "prot_191*.*"

cd ${ZDIR}

zipmerge riksdagens_protokoll_1920-2020.zip \
    ./kb_labb/riksdagens_protokoll_kb-labb_1920-1989.zip \
    ./riksdagens_open_data/riksdagens_protokoll_riksdagens-open-data_1990-2020.zip

