#!/bin/bash

datasets=( "2018-2021" "2014-2017" "2010-2013" "2006-2009" "2002-2005" "1998-2001" "1990-1997" "1980-1989" "1971-1979" )
datatypes=( "csv" "json" "text" "html" )

for ds in ${datasets[@]}; do

    for dt in ${datatypes[@]}; do

        url="https://data.riksdagen.se/dataset/dokument/prot-${ds}.${dt}.zip"

        wget "$url"

    done

done

zipmerge prot-1971-2021.text.zip -i *.text.zip
zipmerge prot-1971-2021.csv.zip -i *.csv.zip
zipmerge prot-1971-2021.json.zip -i *.json.zip
