FROM centos/python-36-centos7

MAINTAINER Collaboratory Platform <platform@humanbrainproject.eu>

ENV UPGRADE_PIP_TO_LATEST=1 ENABLE_INIT_WRAPPER=1

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
RUN yum install -y epel-release && \
        yum-config-manager --enable epel && \
        yum  groupinstall -y 'Development Tools' && \
        yum install -y \
        bzip2-devel \
        cmake \
        cmake3 \
        csh \
        curl \
        Cython \
        freetype-devel \
        gsl-devel \
        hdf5-devel \
        liberation-fonts \
        libtool-ltdl-devel \
        libXext-devel \
        libXrender \
        llvm \
        lsof \
        mpich \
        mpich-devel \
        ncurses-devel \
        pandoc \
        python-devel \
        R \
        readline-devel \
        texlive-latex \
        unzip \
        vim \
        wget \
        && yum  -y clean all

# Set the Switzerland timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

ENV MPICC=/usr/lib64/mpich/bin/mpicc

RUN mkdir -p /tmp/cache/
ENV XDG_CACHE_HOME=/tmp/cache

EXPOSE 8080

USER 1000
