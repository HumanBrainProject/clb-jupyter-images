ARG CENTOS_TAG=8
FROM centos:$CENTOS_TAG

MAINTAINER Collaboratory Platform <platform@humanbrainproject.eu>

USER root

ENV LC_ALL en_US.UTF-8
ENV LANG C.UTF-8
ENV GPG_KEY E3FF2839C048B25C084DEBE9B26995E310250568
ENV PYTHON_VERSION 3.8.0

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="1000"

ARG JUPYTER_HOME="/usr/local/jupyter"
ARG JUPYTER_ENV_HOME="$JUPYTER_HOME/environments"

# Enable PowerTools and epel for hdf5 suport
RUN dnf install -y 'dnf-command(config-manager)' && \
        dnf config-manager --set-enabled PowerTools && \
        dnf install -y epel-release && \
        dnf install -y \
        autoconf \
        automake \
        binutils \
        bison \
        bzip2-devel \
        ca-certificates \
        csh \
        cmake \
        diffstat \
        flex \
        freetype-devel \
        gcc \
        gcc-c++ \
        gdb \
        git \
        glibc-devel \
        glibc-langpack-en \
        gsl-devel \
        hdf5-devel \
        intltool \
        libtool \
        libtool-ltdl-devel \
        lsof \
        ltrace \
        make \
        ncurses-devel \
        openssl-devel \
        patchutils \
        readline-devel \
        unzip \
        vim \
        wget \
        && dnf -y clean all

# Set the Switzerland timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

RUN groupadd -g $NB_GID $NB_USER && \
        useradd -s /bin/bash -m -u $NB_UID -g $NB_GID $NB_USER

RUN mkdir /opt/conda && chown $NB_UID:$NB_GID /opt/conda && \
   ln -sf /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

USER $NB_USER

ARG CONDA_VERSION=4.7.12.1
ARG CONDA_INSTALLER_SHASUM=bfe34e1fa28d6d75a7ad05fd02fa5472275673d5f5621b77380898dee1be15d2

WORKDIR /tmp/

COPY requirements.*.txt /tmp

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
        echo $CONDA_INSTALLER_SHASUM  miniconda.sh | sha256sum -c && \
        /bin/bash miniconda.sh -b -f -p /opt/conda && \
        rm miniconda.sh && \
        echo "conda ${CONDA_VERSION}" >> /opt/conda/conda-meta/pinned && \
        /opt/conda/bin/conda config --system --prepend channels conda-forge && \
        /opt/conda/bin/conda config --system --set auto_update_conda false && \
        /opt/conda/bin/conda config --system --set show_channel_urls true && \
        /opt/conda/bin/conda create --yes -n nbserver --file /tmp/requirements.conda.txt python=3.8 && \
        /opt/conda/bin/conda init && \
        /opt/conda/bin/conda clean -tipsy && \
        echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc


COPY install_packages.sh /tmp
RUN /tmp/install_packages.sh && rm /tmp/install_packages.sh

WORKDIR /home/$NB_USER

# @TODO Remove this when bug is fixed: https://github.com/ipython/ipython/issues/11546
RUN echo 'c.Completer.use_jedi = False' >> ~/.ipython/profile_default/ipython_config.py


EXPOSE 8080
