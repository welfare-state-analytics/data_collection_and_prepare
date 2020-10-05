#!/bin/sh

# This script merges Riksdagens protokoll downloaded from KB-labb and Riksdagens öppna data
# The scripts downloads and merges KB-labb files from Google Drive, and deletes years out-of-scope

cd ~/source/welfare-state-analytics/data/riksdagens_protokoll/kb_labb

# Tanka hem riksdagens protokoll från Google Drive (KB-labb 1847-1989)
gdown https://drive.google.com/uc?id=13_WU4prDr4tU0AQliHRjlOdhIYL1Uq4s
gdown https://drive.google.com/uc?id=13dJuM9NKPIuS-lZGkPIQ8AinsZFrvHa0
gdown https://drive.google.com/uc?id=13Y5_xWMf9UipnoZ1A0RgUL2cyOidVozK

# Slå ihop, och ta bort 1800-talet, (19)00-talet och 1910-talet
zipmerge  riksdagens_protokoll_kb-labb_1920-1989.zip riksdagens_protokoll_content_corpus_1*.zip

zip -d riksdagens_protokoll_kb-labb_1920-1989.zip "prot_18*.*"
zip -d riksdagens_protokoll_kb-labb_1920-1989.zip "prot_190*.*"
zip -d riksdagens_protokoll_kb-labb_1920-1989.zip "prot_191*.*"

# Ta bort tankade filer
rm riksdagens_protokoll_content_corpus_1867-1921.zip
rm riksdagens_protokoll_content_corpus_1922-1944.zip
rm riksdagens_protokoll_content_corpus_1945-1989.zip

# Gör motsvarande för Riksdagens Öppna Data 1971-2020 - ta bort 70-tal & 00-tal
cd ~/source/welfare-state-analytics/data/riksdagens_protokoll/riksdagens_open_data
cp prot-1971-2021.riksdagens.open.data.text.zip riksdagens_protokoll_riksdagens-open-data_1990-2020.zip
zip -d riksdagens_protokoll_riksdagens-open-data_1990-2020.zip "prot_197*.*"
zip -d riksdagens_protokoll_riksdagens-open-data_1990-2020.zip "prot_198*.*"

# Slå samman resultatet
cd ~/source/welfare-state-analytics/data/riksdagens_protokoll/

zipmerge riksdagens_protokoll_1920-2020.zip \
    ./kb_labb/riksdagens_protokoll_kb-labb_1920-1989.zip \
    ./riksdagens_open_data/riksdagens_protokoll_riksdagens-open-data_1990-2020.zip

