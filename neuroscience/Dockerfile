ENV CLB_NB_BASE_VERSION:v0.0.2-icp-base
FROM ebrains/clb-jupyter-nb:$CLB_NB_BASE_VERSION

ENV SDAHOME /usr/local/lib/sda_flex
ENV NESTHOME /usr/local/lib/nest/

RUN yum install -y https://neuron.yale.edu/ftp/neuron/versions/v7.7/nrn-7.7.x86_64-linux.rpm

COPY install_nest.sh /tmp/
RUN /tmp/install_nest.sh

COPY install_sda_flex.sh /tmp/
RUN /tmp/install_sda_flex.sh

USER 0
RUN rm -f /tmp/install*

USER 1000
