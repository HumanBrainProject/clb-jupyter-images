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
        readline-devel \
        texlive-latex \
        unzip \
        vim \
        wget \
        && yum  -y clean all

# Set the Switzerland timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

RUN CC=/usr/lib64/mpich/bin/mpicc pip install mpi4py==3.0.2

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

EXPOSE 8080

# TODO

# Install ffmpeg/libav

# Build SDA FLEX
#ADD external/minimal-sda_flex-7.2.2.tar.gz /opt
#RUN cd /opt/minimal-sda_flex-7.2.2/src && make

# COPY install_scripts/install_amber.sh /tmp/
# RUN bash /tmp/install_amber.sh

# ENV PYTHONPATH /home/jovyan/.local/nrn/lib/python:$PYTHONPATH
# ENV AMBERHOME /opt/amber18
# ENV SDAHOME /opt/minimal-sda_flex-7.2.2
# RUN sed -ie '\|^{|a \ "env":{"PYTHONPATH":"'$AMBERHOME'/lib/python3.6/site-packages/:'$PYTHONPATH'"},' /opt/conda/share/jupyter/kernels/python3/kernel.json && \
#     sed -ie '\|^{|a \ "env":{"PYTHONPATH":"'$AMBERHOME'/lib/python2.7/site-packages/:'$PYTHONPATH'"},' /usr/local/share/jupyter/kernels/python2/kernel.json
# # Switch back to jovyan to avoid accidental container runs as root
# USER $NB_USER

USER 1000
