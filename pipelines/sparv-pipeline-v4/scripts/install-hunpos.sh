#!/bin/bash
# Hunpos
#  https://github.com/mivoq/hunpos


# sudo apt install lib32z1
# cd /tmp
# wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hunpos/hunpos-1.0-linux.tgz
# tar xvf hunpos-1.0-linux.tgz
# mv hunpos-1.0-linux/* $SPARV_DATADIR/bin
# rm -rf hunpos-1.0-linux*

cd /tmp
rm -rf hunpos
git clone https://github.com/mivoq/hunpos.git
mkdir -p hunpos/build
cd hunpos/build
cmake .. -DCMAKE_INSTALL_PREFIX=/tmp/hunpos/install
make
make install
mv -f /tmp/hunpos/install/bin/* $SPARV_DATADIR/bin
# mkdir -p $SPARV_DATADIR/lib $SPARV_DATADIR/include
# mv -f /tmp/hunpos/install/lib/* $SPARV_DATADIR/lib/
# mv -f /tmp/hunpos/install/include/* $SPARV_DATADIR/include/
cd /tmp
rm -rf ./hunpos
