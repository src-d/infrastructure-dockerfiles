FROM srcd/ml-infra-base-python

ENV NVIDIA_DRIVER_VERSION 410.78
ENV CUDA_UBUNTU 1804
ENV CUDA_VERSION 10.0.130
ENV CUDA_VERSION_DASH 10-0
ENV CUDA_VERSION_MAJOR 10.0
ENV CUDNN_VERSION 7_7.5.0.56

# nvidia driver layer
RUN apt-get update && \
    apt-get install -y kmod && \
    mkdir -p /opt/nvidia && cd /opt/nvidia/ && \
    wget http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run -O /opt/nvidia/driver.run && \
    chmod +x /opt/nvidia/driver.run && \
    /opt/nvidia/driver.run -a -s --no-nvidia-modprobe --no-kernel-module --no-unified-memory --no-x-check --no-opengl-files && \
    rm -rf /opt/nvidia && \
    apt-get remove -y kmod && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* /usr/bin/nvidia-xconfig /usr/lib/xorg /usr/share/doc/* /usr/share/applications

# cuda layer
RUN apt-get update && \
    apt-get install -y gnupg && \
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu${CUDA_UBUNTU}/x86_64/cuda-repo-ubuntu${CUDA_UBUNTU}_${CUDA_VERSION}-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu${CUDA_UBUNTU}_${CUDA_VERSION}-1_amd64.deb && \
    rm cuda-repo-ubuntu${CUDA_UBUNTU}_${CUDA_VERSION}-1_amd64.deb && \
    wget --retry-connrefused -O - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${CUDA_UBUNTU}/x86_64/7fa2af80.pub | apt-key add - && \
    apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        cuda-cublas-${CUDA_VERSION_DASH} \
        cuda-cudart-${CUDA_VERSION_DASH} \
        cuda-cufft-${CUDA_VERSION_DASH} \
        cuda-curand-${CUDA_VERSION_DASH} \
        cuda-cusolver-${CUDA_VERSION_DASH} \
        cuda-cusparse-${CUDA_VERSION_DASH} && \
    sed -i 's#"$#:/usr/local/cuda-${CUDA_VERSION_MAJOR}/bin"#' /etc/environment && \
    apt-get remove -y gnupg && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/cuda-${CUDA_VERSION_MAJOR}/bin

# cudnn layer
RUN wget https://storage.googleapis.com/deb.cdn.sourced.tech/libcudnn${CUDNN_VERSION}-1%2Bcuda${CUDA_VERSION_MAJOR}_amd64.deb && \
    dpkg -i libcudnn${CUDNN_VERSION}-1+cuda${CUDA_VERSION_MAJOR}_amd64.deb && \
    rm libcudnn${CUDNN_VERSION}-1+cuda${CUDA_VERSION_MAJOR}_amd64.deb && \
    rm -rf /usr/share/doc/*
