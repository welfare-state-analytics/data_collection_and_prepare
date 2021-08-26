#!/bin/bash

nohup ./sparv-in-yearly-chunks.sh --pattern="prot_YYYY*.txt" --force --output-folder=./data riksdagens_protokoll_1920-2020.zip  1920 1929 > 1920-29.log  2>&1 &

