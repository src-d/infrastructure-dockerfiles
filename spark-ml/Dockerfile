FROM srcd/spark:2.2.3

# Based on core-ml, modified to be used on Debian Stretch

ENV BROWSER=/browser \
    LC_ALL=en_US.UTF-8

# build environment
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      apt-utils ca-certificates gnupg2 locales gcc g++ wget apt-transport-https \
      python3 python3-dev python3-distutils-extra python3-cffi && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    wget -O - https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install --no-cache-dir cython && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo '#!/bin/bash\n\necho\n\echo "  $@"\n\echo\n' > /browser && \
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
ADD numpy-site.cfg /root/.numpy-site.cfg
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      libfftw3-3 libfftw3-dev gfortran && \
    export NPY_NUM_BUILD_JOBS=$(getconf _NPROCESSORS_ONLN) && \
    echo $NPY_NUM_BUILD_JOBS && \
    pip3 install --no-cache-dir numpy scipy && \
    apt-get remove -y libfftw3-dev gfortran && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# pyyaml
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libyaml-dev libyaml-0-2 && \
    pip3 install --no-cache-dir pyyaml && \
    apt-get remove -y libyaml-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# common Ubuntu packages
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends nano curl cpio lzop gdb \
      lldb libpython3-dbg net-tools build-essential pkg-config graphviz git vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Pillow
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libjpeg62-turbo-dev libpng-dev \
      libfreetype6-dev libxft-dev libjpeg62-turbo libfreetype6 libxft2 && \
    pip3 install --no-cache-dir Pillow-SIMD && \
    apt-get remove -y libjpeg62-turbo-dev libpng-dev zlib1g-dev libfreetype6-dev libxft-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# system packages - expected to change rarely
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libsnappy-dev && \
    pip3 install --no-cache-dir requests h5py lz4 tqdm jinja2 humanfriendly stringcase pympler \
      cachetools configargparse parquet pydot flask sqlalchemy sqlalchemy-utils flake8 && \
    apt-get remove -y libsnappy-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# plotting
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libcairo2 && \
    pip3 install --no-use-pep517 matplotlib cairocffi seaborn && \
    python3 -c "import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# stats, classic CS
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends libxml2 libxml2-dev zlib1g-dev && \
    pip3 install pandas statsmodels lapjv python-igraph && \
    apt-get remove -y libxml2-dev zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# the rest of the layers can change frquently
# NLP
RUN pip3 install spacy gensim wmd datasketch fasttext && python3 -m spacy download en_core_web_md
# Generic ML
RUN pip3 install xgboost lightgbm catboost scikit-learn hdbscan umap-learn
# *Frequent updates zone*
RUN pip3 install asdf ipython tensorflow-gpu tensorflow-hub keras torch
