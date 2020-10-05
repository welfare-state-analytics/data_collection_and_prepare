# Command Scripts

## Download content JSON files from KB-labb

```bash

poetry shell

PYTHONPATH=. nohup python ./scripts/kb_labb/download_content_json.py protokoll riksdagens_protokoll_kb_labb_202000930.zip >& riksdagens_protokoll_kb_labb_202000930.log &

```

## Extract text from KB-lan JSON content file

```bash

poetry shell

PYTHONPATH=. python scripts/kb_labb/extract_json_text.py --source-filename data/riksdagens_protokoll/riksdagens_protokoll_kb_labb_content_json_202000930.zip --target-filename data/riksdagens_protokoll/riksdagens_protokoll_kb_labb_text_202000930.zip

```

## Merge riksdagens protokoll from KB-lab and Riksdagens öppna data

See scripts `merge_kb-labb-rod-yyyymmdd.sh`in /scripts/riksdagens_protokoll/step.1-compile-corpus

Example (if zips are ready for merge):

```bash
zipmerge riksdagens_protokoll_1920-2020.zip \
    ./kb_labb/riksdagens_protokoll_kb-labb_1920-1989.zip \
    ./riksdagens_open_data/riksdagens_protokoll_riksdagens-open-data_1990-2020.zip
```

## Deposit file to Google Drive

Given that rclone configuration `work_google_drive` exists:

```bash
rclone copy riksdagens_protokoll_1920-2020.zip work_google_drive:
```
