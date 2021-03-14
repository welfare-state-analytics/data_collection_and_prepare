#!/bin/bash
# HFST-swener

echo "HFST-SWENER requires GNU M4 (sudo apt install m4)"

HFST_SWENER_PACKAGE=hfst-swener-0.9.3
HFST_SWENER_URL=http://www.ling.helsinki.fi/users/janiemi/finclarin/ner/${HFST_SWENER_PACKAGE}.tgz

cd /tmp

rm -rf ${HFST_SWENER_PACKAGE}*

wget  ${HFST_SWENER_URL}
tar xvzf ${HFST_SWENER_PACKAGE}.tgz

cd /tmp/${HFST_SWENER_PACKAGE}/scripts
sed -i 's:#! \/usr/bin/env python:#! /usr/bin/env python2:g' *.py
cd /tmp/${HFST_SWENER_PACKAGE}

./configure --prefix=$SPARV_DATADIR/bin/hfst_swener

make

rm -rf $SPARV_DATADIR/bin/hfst*
make install

cd $SPARV_DATADIR/bin
ln -s hfst_swener/bin/hfst-swener hfst-swener

cd /tmp

rm -rf ${HFST_SWENER_PACKAGE}*
