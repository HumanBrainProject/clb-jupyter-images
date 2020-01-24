FROM clb-jupyter-nb-builder:latest

USER 0
RUN yum install -y https://neuron.yale.edu/ftp/neuron/versions/v7.7/nrn-7.7.x86_64-linux.rpm \
        && yum -y clean all

USER 1000
ENV SDAHOME /opt/app-root/lib/sda_flex
ENV NESTHOME /opt/app-root/lib/nest/

COPY install_nest.sh /tmp/
RUN /tmp/install_nest.sh

COPY install_sda_flex.sh /tmp/
RUN /tmp/install_sda_flex.sh

USER 0
RUN rm -f /tmp/install*

USER 1000
