FROM ubuntu:18.04

ENV BROWSER=/browser \
    LC_ALL=en_US.UTF-8

# build environment
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      apt-utils ca-certificates gnupg2 locales gcc g++ wget \
      python3 python3-dev python3-distutils python3-cffi && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    wget -O - https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install --no-cache-dir cython && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo '#!/bin/bash\n\
\n\
echo\n\
echo "  $@"\n\
echo\n\' > /browser && \
    chmod +x /browser

# Intel MKL
RUN echo "deb https://apt.repos.intel.com/mkl all main" > /etc/apt/sources.list.d/intel-mkl.list && \
    wget -O - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB | \
    apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends intel-mkl-gnu-c-2019.1-144 && \
    rm -rf /opt/intel/documentation_2019 && \
    ln -s /opt/intel/compilers_and_libraries_*/linux/mkl /opt/intel/mkl && \
    printf '/opt/intel/mkl/lib/intel64_lin' >> /etc/ld.so.conf.d/mkl.conf && \
    ldconfig && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# numpy & scipy
ADD etc/numpy-site.cfg /root/.numpy-site.cfg
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      libfftw3-3 libfftw3-dev gfortran libgfortran4 && \
    export NPY_NUM_BUILD_JOBS=$(getconf _NPROCESSORS_ONLN) && \
    echo $NPY_NUM_BUILD_JOBS && \
    pip3 -v install --no-cache-dir numpy scipy\>=1.2.0rc1 --no-binary numpy --no-binary scipy && \
    apt-get remove -y libfftw3-dev gfortran && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

# pyyaml
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libyaml-dev libyaml-0-2 && \
    pip3 install --no-cache-dir pyyaml && \
    apt-get remove -y libyaml-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

# common Ubuntu packages
# build-essential requires dpkg-dev, which we do not need
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-suggests --no-install-recommends nano curl cpio lzop pxz gdb \
      less tmux libpython3-dbg net-tools libc6-dev make pkg-config graphviz git vim unzip psmisc \
      bzip2 xz-utils patch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/* /usr/share/doc-base/* /usr/share/X11 /usr/share/icons \
    /usr/share/applications /usr/share/info/* && \
    echo 'bind ^P gotoline main' > /root/.nanorc && \
    sed -i 's/HISTSIZE=1000/HISTSIZE=-1/' /root/.bashrc && \
    sed -i 's/HISTFILESIZE=2000/HISTFILESIZE=-1/' /root/.bashrc && \
    echo "PROMPT_COMMAND='history -a;history -n'" >> /root/.bashrc && \
    echo "source /usr/share/bash-completion/completions/fzf" >> /root/.bashrc && \
    echo "source /usr/share/bash-completion/key-bindings.bash" >> /root/.bashrc && \
    wget http://mirrors.kernel.org/ubuntu/pool/universe/f/fzf/fzf_0.18.0-2_amd64.deb && \
    dpkg -i fzf_0.18.0-2_amd64.deb && \
    dpkg-deb -x fzf_0.18.0-2_amd64.deb /tmp/fzf && \
    mv /tmp/fzf/usr/share/doc/fzf/examples/key-bindings.bash /usr/share/bash-completion/key-bindings.bash && \
    rm -rf /tmp/fzf && \
    rm fzf_0.18.0-2_amd64.deb

# system packages - expected to change rarely
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libsnappy-dev libsnappy1v5 && \
    pip3 install --no-cache-dir 'urllib3<1.25' requests h5py lz4 tqdm jinja2 humanfriendly stringcase pympler \
      cachetools configargparse parquet pydot flask sqlalchemy sqlalchemy-utils pymongo flake8 && \
    apt-get remove -y libsnappy-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/gdrive-org/gdrive/releases/download/2.1.0/gdrive-linux-x64 -O gdrive && \
    chmod +x gdrive && \
    mv gdrive /usr/local/bin

# plotting
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libcairo2 && \
    pip3 install --no-cache-dir matplotlib cairocffi seaborn && \
    python3 -c "import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Pillow and scikit-image
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libjpeg-turbo8-dev libpng-dev \
      libfreetype6-dev libxft-dev libjpeg-turbo8 libpng16-16 libfreetype6 libxft2 && \
    pip3 install --no-cache-dir scikit-image && \
    pip3 uninstall -y pillow && \
    pip3 install --no-cache-dir Pillow-SIMD && \
    apt-get remove -y libjpeg-turbo8-dev libpng-dev zlib1g-dev libfreetype6-dev libxft-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# stats, classic CS
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libxml2 libxml2-dev zlib1g-dev && \
    pip3 install --no-cache-dir pandas statsmodels lapjv python-igraph && \
    apt-get remove -y libxml2-dev zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# the rest of the layers may change frequently

# NLP
RUN pip3 install --no-cache-dir spacy gensim wmd datasketch fasttext && \
    python3 -m spacy download en_core_web_md && \
    rm -rf /usr/local/bin/rst2* /usr/local/bin/__pycache__/rst2*

# Generic ML
RUN pip3 install --no-cache-dir xgboost lightgbm catboost scikit-learn hdbscan umap-learn && \
    rm -rf /root/.cache/pip

# *Frequent updates zone*
RUN pip3 install --no-cache-dir 'protobuf<3.8.0' asdf ipython
