FROM srcd/ml-infra-jh-cuda-python

RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends cuda-cudart-dev-10-0 cuda-nvcc-10-0 cuda-cusparse-dev-10-0 && \
    pip3 install --no-cache-dir https://download.pytorch.org/whl/cu100/torch-1.1.0-cp36-cp36m-linux_x86_64.whl && \
    pip3 install --no-cache-dir https://download.pytorch.org/whl/cu100/torchvision-0.3.0-cp36-cp36m-linux_x86_64.whl && \
    pip3 install --verbose --no-cache-dir --no-binary torch-scatter torch-scatter && \
    pip3 install --verbose --no-cache-dir --no-binary torch-sparse torch-sparse && \
    pip3 install --verbose --no-cache-dir --no-binary torch-cluster torch-cluster && \
    pip3 install --verbose --no-cache-dir torch-spline-conv && \
    apt-get remove -y cuda-cudart-dev-10-0 cuda-nvcc-10-0 cuda-cusparse-dev-10-0 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN pip3 install --no-cache-dir torch-geometric

RUN pip3 install https://s3.us-east-2.amazonaws.com/dgl.ai/wheels/cuda10.0/dgl-0.3-cp36-cp36m-manylinux1_x86_64.whl
