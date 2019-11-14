FROM clb-jupyter-nb-builder:latest

RUN mkdir /opt/app-root/clb
ENV AMBERHOME /opt/app-root/clb/amber/
ENV SDAHOME /opt/app-root/lib/sda_flex
ENV NEURONHOME /opt/app-root/clb/nrn
ENV NESTHOME /opt/app-root/clb/nest/

COPY install_nest.sh /tmp/
RUN /tmp/install_nest.sh

COPY install_neuron.sh /tmp/
RUN  /tmp/install_neuron.sh

COPY install_sda_flex.sh /tmp/
RUN /tmp/install_sda_flex.sh

COPY install_ambertools.sh /tmp/
RUN /tmp/install_ambertools.sh

RUN rm -f /tmp/install*
