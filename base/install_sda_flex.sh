#!/bin/bash

set -eo pipefail

(
    set -eo pipefail
    # run without privileges
    setpriv --reuid=$NB_UID --regid=$NB_GID --clear-groups


    SDA_VERSION=7.2.3

    wget -q -O /tmp/sda_flex.tar.gz https://github.com/HumanBrainProject/clb-jupyter-images/raw/external/external/sda_flex-${SDA_VERSION}.tar.gz
    cd /tmp
    tar xzf /tmp/sda_flex.tar.gz
    cd sda_flex-${SDA_VERSION}/src
    make
    cd /tmp/
)
mv sda_flex-${SDA_VERSION} $SDAHOME

rm /tmp/sda_*
