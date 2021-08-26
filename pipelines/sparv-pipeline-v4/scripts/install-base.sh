#!/bin/bash

BUILD_PACKAGES="build-essential pkg-config libtool gcc make automake subversion autoconf cmake"

set -ex
apt -qq update
mkdir -p /usr/share/man/man1

#    && apt -yqq dist-upgrade \

apt install -y -qq --no-install-recommends \
    $BUILD_PACKAGES \
    ca-certificates locales time gettext \
    libsqlite3-dev \
    m4 ocaml-nox \
    bison flex \
    curl wget zip unzip bzip2 tar git \
    python2.7-minimal

# Recommended install if using pyenv:
# https://github.com/pyenv/pyenv/wiki/Common-build-problems
if [ "$PYENV_ROOT" != ""]; then
    echo "warning: you might need to reinstall Python to enable sqlite3"
    apt install -y libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev python-openssl
    echo "you might need to replace libreadline-dev with libedit-dev"
fi

locale-gen en_US.UTF-8 && dpkg-reconfigure locales
rm /bin/sh && ln -s /bin/bash /bin/sh
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8

# Git LFS
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt -qq update
apt install -y -qq --no-install-recommends git-lfs
git lfs install

# Java 8
apt install -y -qq --no-install-recommends apt-transport-https dirmngr gnupg software-properties-common
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
apt update
apt install -y -qq --no-install-recommends adoptopenjdk-8-hotspot

# Python 2
python -m pip install --upgrade pip
if [ ! -f /usr/bin/python2 ]; then
    ln -s /usr/bin/python2.7 /usr/bin/python2 ;
fi

rm -rf /var/lib/apt/list
