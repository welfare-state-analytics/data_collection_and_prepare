#!/bin/bash

STANFORD_PARSER_VERSION="${STANFORD_PARSER_VERSION:=4.0.0}"

cd $SPARV_DATADIR/bin

wget http://nlp.stanford.edu/software/stanford-corenlp-${STANFORD_PARSER_VERSION}.zip

unzip -qq stanford-corenlp-${STANFORD_PARSER_VERSION}
mv -f stanford-corenlp-${STANFORD_PARSER_VERSION} stanford_parser

rm -f http://nlp.stanford.edu/software/stanford-corenlp-${STANFORD_PARSER_VERSION}.zip
