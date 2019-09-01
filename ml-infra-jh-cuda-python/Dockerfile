FROM srcd/ml-infra-cuda-python

COPY start.sh /usr/local/bin
COPY start-notebook.sh /usr/local/bin
COPY start-singleuser.sh /usr/local/bin
COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN ln -s /root /home/root && \
    mkdir -p /usr/local/etc/jupyter/nbconfig && \
    pip3 install --no-cache-dir nbgitpuller jupyterhub==0.9.4 jupyter_contrib_nbextensions jupyter_nbextensions_configurator ipywidgets && \
    jupyter contrib nbextension install && \
    jupyter nbextensions_configurator enable && \
    echo '{\
  "load_extensions": {\
    "nbextensions_configurator/config_menu/main": true,\
    "execute_time/ExecuteTime": true,\
    "notify/notify": true,\
    "jupyter-js-widgets/extension": true\
  },\
  "ExecuteTime": {\
    "display_in_utc": true\
  }\
}' > /usr/local/etc/jupyter/nbconfig/notebook.json && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix && \
    sed -i 's/self.notary.mark_cells(nb, trusted)/self.notary.mark_cells(nb, True)/' /usr/local/lib/python3.6/dist-packages/notebook/services/contents/manager.py && \
    mainjs=$(echo /usr/local/lib/python3.*/dist-packages/notebook/static/terminal/js/main.min.js) && \
    sed -i '/window.terminal = terminal;/a function focus() {\
    terminal.term.focus();\
    if (!terminal.term.isFocused) {\
        setTimeout(focus, 100);\
    }\
}; \
setTimeout(focus, 100);' $mainjs && \
    echo "" >>$mainjs && \
    echo '$(window).keydown(function(event) {\
  if (event.keyCode == 67 && event.ctrlKey && event.shiftKey) {\
    navigator.clipboard.writeText(terminal.term.getSelection());\
    event.preventDefault();\
  }\
});' >>$mainjs && \
    sed -i '/shell_command=shell,/a\ \ \ \ \ \ \ \ term_settings={"cwd": "/user/" + os.getenv("JUPYTERHUB_USER"), "type": "xterm-color"},' /usr/local/lib/python3.*/dist-packages/notebook/terminal/__init__.py

# We forcefully mark all the notebooks as trusted

EXPOSE 8888
ENV NB_USER root
ENV NB_UID 0
ENV NB_GID 0
ENV CONDA_DIR /we/will/use/anaconda/over/my/dead/body

CMD ["start-notebook.sh"]
