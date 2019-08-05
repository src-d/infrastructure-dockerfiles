FROM srcd/ml-infra-cuda-python

COPY start.sh /usr/local/bin
COPY start-notebook.sh /usr/local/bin
COPY start-singleuser.sh /usr/local/bin
COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN ln -s /root /home/root && \
    mkdir -p /usr/local/etc/jupyter/nbconfig && \
    pip3 install --no-cache-dir nbgitpuller jupyterhub==0.9.4 jupyter_contrib_nbextensions jupyter_nbextensions_configurator && \
    jupyter contrib nbextension install && \
    jupyter nbextensions_configurator enable && \
    echo '{\
  "load_extensions": {\
    "nbextensions_configurator/config_menu/main": true,\
    "execute_time/ExecuteTime": true,\
    "notify/notify": true\
  },\
  "ExecuteTime": {\
    "display_in_utc": true\
  }\
}' > /usr/local/etc/jupyter/nbconfig/notebook.json && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix

EXPOSE 8888
ENV NB_USER root
ENV NB_UID 0
ENV NB_GID 0
ENV CONDA_DIR /we/will/use/anaconda/over/my/dead/body

CMD ["start-notebook.sh"]
