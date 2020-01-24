#!/bin/bash

set -eo pipefail

NEURON_VERSION=7.7
cd /tmp
wget -q -O /tmp/nrn.tar.gz https://neuron.yale.edu/ftp/neuron/versions/v7.7/7.7.2/nrn-7.7.2.tar.gz
tar -xvzf nrn.tar.gz

cd nrn-${NEURON_VERSION}
CC=/usr/lib64/mpich/bin/mpicc ./configure \
                              --without-iv \
                              --with-paranrn=dynamic \
                              --with-readline=yes \
                              --with-nrnpython=dynamic \
                              --prefix=$NEURONHOME
make -j install

rm -rf /tmp/nrn*
