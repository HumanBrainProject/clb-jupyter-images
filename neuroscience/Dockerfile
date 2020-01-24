FROM clb-jupyter-nb-builder:latest

ENV SDAHOME /opt/app-root/lib/sda_flex
ENV NEURONHOME /opt/app-root/lib/nrn
ENV NESTHOME /opt/app-root/lib/nest/
ENV PYTHONPATH $NEURONHOME/lib/python:$PYTHONPATH
ENV PATH $NEURONHOME/x86_64/bin:$PATH

COPY install_nest.sh /tmp/
RUN /tmp/install_nest.sh

COPY install_neuron.sh /tmp/
RUN  /tmp/install_neuron.sh

COPY install_sda_flex.sh /tmp/
RUN /tmp/install_sda_flex.sh

USER 0
RUN rm -f /tmp/install*

USER 1000
