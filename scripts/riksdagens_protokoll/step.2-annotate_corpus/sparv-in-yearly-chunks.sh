#!/bin/bash

text_corpus_filename=~/source/welfare-state-analytics/data/riksdagens_protokoll/riksdagens_protokoll_1920-2020.zip
sparv4=~/source/welfare-state-analytics/westac_data/pipelines/sparv-pipeline-v4/sparv4

for year in {1920..1920};
do
    echo "Iteration $year"

    mkdir $year/source

    cp sparv4-config.yaml $year/config.yaml

    cd $year

    unzip -d ./source ${text_corpus_filename} "prot_${year}*"

    sparv4

    rm -rf source annotations 

done
