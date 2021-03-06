#!/bin/bash
# HFST-swener

HSFT_SWENER_PACKAGE=hfst-swener-0.9.3
HFST_SWENER_URL=http://www.ling.helsinki.fi/users/janiemi/finclarin/ner/${HSFT_SWENER_PACKAGE}.tgz

cd /tmp

rm -rf ${HSFT_SWENER_PACKAGE}*

wget  ${HFST_SWENER_URL}
tar xvz ${HSFT_SWENER_PACKAGE}.tgz

cd /tmp/${HSFT_SWENER_PACKAGE}/scripts
sed -i 's:#! \/usr/bin/env python:#! /usr/bin/env python2:g' *.py
cd /tmp/${HSFT_SWENER_PACKAGE}

./configure --prefix=$SPARV_DATADIR/bin/hsft_swener

make
make install

cd $SPARV_DATADIR/bin
ln -s hfst_swener/bin/hfst-swener hfst-swener

cd /tmp

rm -rf ${HSFT_SWENER_PACKAGE}*
