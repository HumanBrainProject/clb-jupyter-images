#!/bin/bash
set -eo pipefail

cd /tmp
# run without privileges
setpriv --reuid=$NB_UID --regid=$NB_GID --clear-groups bash <<EOF

    set -eo pipefail

    # Install libneurosim as a dependency of nest and nest
    NEUROSIM_COMMIT=03646747c8fe64fa3439ac2d282623b659f60c22

    wget -q -O libneurosim.zip   https://github.com/INCF/libneurosim/archive/${NEUROSIM_COMMIT}.zip
    unzip libneurosim.zip
    cd libneurosim-${NEUROSIM_COMMIT}/
    ./autogen.sh
    ./configure --prefix=/usr/local

    NEST_VERSION=2.18.0

    cd /tmp
    wget -q -O nest.tar.gz https://github.com/nest/nest-simulator/archive/v${NEST_VERSION}.tar.gz
    tar xzf nest.tar.gz
    cd nest-simulator-${NEST_VERSION}/
    cmake3 -DCMAKE_INSTALL_PREFIX:PATH=$NESTHOME \
           -Dwith-libneurosim=/usr/local -Dwith-python=3 \
           .
EOF

cd /tmp/libneurosim-${NEUROSIM_COMMIT}
make install
cd /tmp/nest-simulator-${NEST_VERSION}/
make install

rm -rf /tmp/nest*
rm -rf /tmp/libneuro*
