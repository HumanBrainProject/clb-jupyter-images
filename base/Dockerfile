FROM quay.io/jupyteronopenshift/s2i-minimal-notebook-py36:v2.3.0

MAINTAINER Collaboratory Platform <platform@humanbrainproject.eu>

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
RUN yum install –y epel-release && \
        yum-config-manager --enable epel && \
        yum  groupinstall -y 'Development Tools' && \
        yum install -y \
        autoconf \
        automake \
#        build-essential \
        bzip2 \
        ca-certificates \
        cmake \
        curl \
        Cython \
        emacs-nox \
        liberation-fonts \
        git \
        less \
        libav-tools \
        bzip2-devel \
        freetype-devel \
        gsl-devel \
        hdf5-devel \
        libtool-ltdl-devel \
        mpich-devel \
        ncurses-devel \
        libpng-devel \
        readline-devel \
        libsm6 \
        libtool \
        libXext-devel \
        libxml2-devel \
        libXrender \
        libxslt-devel \
        lmodern \
        locales \
        lsof \
        mpich \
        pandoc \
        pdb2pqr \
        python-devel \
#         r-base \
        texlive-latex \
        unzip \
        vim \
        wget \
        fuse-libs \
        fuse \
        fuse-devel \
 && apt-get -yq --no-install-recommends -t stretch-backports install llvm-3.8-devel \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# Set the Switzerland timezone
RUN echo "Europe/Zurich" > /etc/timezone && \
        echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
        locale-gen

# Build SDA FLEX
ADD external/minimal-sda_flex-7.2.2.tar.gz /opt
RUN cd /opt/minimal-sda_flex-7.2.2/src && make

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.15.0/tini && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create jovyan user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER $CONDA_DIR

USER $NB_USER

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work

# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION 4.5.1
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "0c28787e3126238df24c5d4858bd0744 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    conda clean -tipsy


# Install Jupyter Notebook and Hub
RUN conda install --quiet --yes \
    'tornado=4.*' \
    'ipython=6.1.*' \
    'notebook=5.0.*' \
    'jupyterhub=0.7.*' \
    'jupyterlab=0.24.*' \
    'pip=9.*' \
    && rm -rf /opt/conda/pkgs/* \
    && conda clean -tipsy

# Configure container startup
ENTRYPOINT ["/usr/local/bin/start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start-notebook.sh /usr/local/bin/
COPY singleuser.sh /usr/local/bin/
COPY start.sh /usr/local/bin/

# custom css
RUN mkdir -p /home/$NB_USER/.jupyter/custom
COPY hbp-notebook-customization/custom.css /home/$NB_USER/.jupyter/custom

# Install NEST, and Python 2 & 3 packages
# Python 3 first as it's the default for Jupyter

COPY install_scripts/install_py3.sh /tmp/
RUN bash /tmp/install_py3.sh

COPY install_scripts/install_py2.sh /tmp/
RUN bash /tmp/install_py2.sh
# Install nest AFTER Python so it can autodetect and install Python libs
COPY install_scripts/install_nest.sh /tmp/
RUN bash /tmp/install_nest.sh

# Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Avtivate nglview widget
RUN jupyter nbextension enable --py nglview --sys-prefix

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg $CONDA_DIR/envs/python2/bin/python -c "import matplotlib.pyplot"


# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime and to allow the notebook server running out of the root
# environment to find it. Also, activate the python2 environment upon kernel
# launch.
USER root

RUN pip install kernda --no-cache && \
    $CONDA_DIR/envs/python2/bin/python -m ipykernel install && \
    kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json && \
    pip uninstall kernda -y

# Installing Neuron here because:
# 1. 7.4 installed from deb > needs root
# 2. 7.6 is compiled locally against the python3 and 2 interpreters, which are
# only available once instal_python2.sh is run. This could be improved by moving
# the python 2 installatation higher.
COPY install_scripts/install_neuron.sh /tmp/
RUN bash /tmp/install_neuron.sh

# Install PyNN after NEST and Neuron so it can complete some setup tasks
RUN $CONDA_DIR/bin/pip2 install 'pyNN==0.9.*' && \
    $CONDA_DIR/bin/pip3 install 'pyNN==0.9.*'

COPY install_scripts/install_amber.sh /tmp/
RUN bash /tmp/install_amber.sh

ENV PYTHONPATH /home/jovyan/.local/nrn/lib/python:$PYTHONPATH
ENV AMBERHOME /opt/amber18
ENV SDAHOME /opt/minimal-sda_flex-7.2.2
RUN sed -ie '\|^{|a \ "env":{"PYTHONPATH":"'$AMBERHOME'/lib/python3.6/site-packages/:'$PYTHONPATH'"},' /opt/conda/share/jupyter/kernels/python3/kernel.json && \
    sed -ie '\|^{|a \ "env":{"PYTHONPATH":"'$AMBERHOME'/lib/python2.7/site-packages/:'$PYTHONPATH'"},' /usr/local/share/jupyter/kernels/python2/kernel.json
# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
