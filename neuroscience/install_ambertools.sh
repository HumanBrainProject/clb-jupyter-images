#!/bin/bash

set -eo pipefail

mkdir $AMBERHOME

wget -qO /tmp/amber18.tar.bz2 https://github.com/HumanBrainProject/clb-jupyter-images/raw/external/external/AmberTools19-minimal.tar.bz2
cd $(dirname $AMBERHOME)
tar xjf /tmp/amber18.tar.bz2 -C amber --strip-components 1
cd amber
./configure -mpi -noX11 --with-python $(which python)
make install

rm -f /tmp/AmberTools*
