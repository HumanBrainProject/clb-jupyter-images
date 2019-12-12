#!/bin/bash
set -ex

. /opt/conda/etc/profile.d/conda.sh
conda activate nbserver
pip install --no-cache-dir -r /tmp/requirements.pip.txt
pip install --no-cache-dir -r /tmp/requirements.tvb.txt
rm /tmp/requirements.*.txt
rm -rf $XDG_CACHE_HOME/*

jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        jupyter-matplotlib \
        jupyterlab_bokeh \
        @krassowski/jupyterlab_go_to_definition \
        jupyterlab-topbar-extension \
        jupyterlab-system-monitor

jupyter lab build
jupyter notebook --generate-config
mkdir -p /home/$NB_USER/.ipython/profile_default/startup/
rm -rf $XDG_CACHE_HOME/*
conda clean -tipsy

MPLBACKEND=Agg python -c "import matplotlib.pyplot"
echo 'from clb_nb_utils import oauth as clb_oauth' >> ~/.ipython/profile_default/startup/30-clb-nb-utils.py
echo "conda activate nbserver" >> ~/.bashrc
