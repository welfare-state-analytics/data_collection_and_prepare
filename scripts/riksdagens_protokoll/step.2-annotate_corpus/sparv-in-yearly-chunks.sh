#!/bin/bash

set -e

usage()
{
  printf 'Usage: %s corpus-filename start-year stop-year --pattern="pattern"--output-folder="folder" [--force]\n' "$0"
  printf '\t%s\n' "-p, --pattern: filename pattern for each year, must contain YYYY literal"
  printf '\t%s\n' "-p, --output-folder: where to put the resulting data"
  printf '\t%s\n' "-f, --force: overwrite year-folder if it already exists"
  printf '\t%s\n' "-h, --help:  prints help"
  exit 0
}

#text_corpus_filename=~/source/welfare-state-analytics/data/riksdagens_protokoll/riksdagens_protokoll_1920-2020.zip
#sparv4=~/source/welfare-state-analytics/westac_data/pipelines/sparv-pipeline-v4/sparv4

corpus_filename=""
start_year=0
stop_year=0
pattern_template=""
force="no"
output_folder=""
positionals=()
positionals_count=0

parse_opts()
{
  while test $# -gt 0
  do
    key="$1"
    case "$key" in
      -f|--force)
        force="yes"
        ;;
      -p=*|--pattern=*)
        pattern_template="${1#*=}"
        ;;
      -o=*|--output-folder=*)
        output_folder="${1#*=}"
        ;;
      *)
        positional="$key"
        positionals+=("$positional")
        positionals_count=$((positionals_count + 1))
        ;;
    esac
    shift
  done
}

parse_opts "$@"
set -- "${positionals[@]}"

if test ! $# -eq 3; then
    printf '%s\n' 'Please specify corpus filename and start & stop year!'
    usage
fi

if [ "$pattern_template" == "" ]; then
    printf '%s\n' 'Please specify non-overlapping filename template containing YYYY for each year!'
    usage
fi

if [[ "$pattern_template" != *"YYYY"* ]]; then
    printf '%s\n' 'Pattern must contain YYYY literal (will be replaced for processed year)!'
    usage
fi

if [ "$output_folder" == "" ]; then
    printf '%s\n' 'Thee might not but specifyeth an did output foldethr!'
    usage
fi

corpus_filename=$1
start_year=$2
stop_year=$3

if [ "$start_year" -gt "$stop_year" ] 2>/dev/null
then
    printf '%s\n' 'Please specify valid years range'
    usage
fi

if [ $start_year -lt 1900 ] || [ $start_year -gt 2020 ] || [ $stop_year -gt 2020 ]; then
    printf '%s\n' 'Please specify year within valid year range!'
    usage
fi

echo "Using corpus $corpus_filename with pattern '$pattern_template' for $start_year to $stop_year and target folder $output_folder"

mkdir -p $output_folder

#for year in {1920..2020};
for year in $(seq $start_year $stop_year);
do
    files_pattern=${pattern_template//YYYY/$year}

    echo "processing: $year using pattern $files_pattern"


    if [ -d ./$year ]; then
        if [ "$force" == "yes" ]; then
            rm -rf ./$year
        else
            echo " => warning: year $year exists (skipping)"
            continue
        fi
    fi

    mkdir -p ./$year/source

    cp ./config-template.yaml $year/config.yaml

    set +e
    unzip -qq -d  ./$year/source ${corpus_filename} "$files_pattern"
    set -e

    if [ -z "$(ls -A ./$year/source)" ]; then
        echo " => warning: year $year has NO MATCHING files (skipping)"
        rm -rf $year
        continue
    fi

    cd $year

    sparv4 run

    cd ..

    xml_filename=$output_folder/riksdagens-protokoll.$year.sparv4.xml.zip
    rm -f $xml_filename
    zip -jD $xml_filename ./$year/export/xml/*.xml

    csv_filename=$output_folder/riksdagens-protokoll.$year.sparv4.csv.zip
    rm -f $csv_filename
    zip -jD $csv_filename ./$year/export/csv/*.csv

    rm -rf $year

done
