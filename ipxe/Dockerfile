FROM debian:buster-slim as builder

ARG VLAN

ENV _clean "rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*"
ENV _apt_clean "eval apt-get clean && $_clean"
ENV _ipxe_dependencies "git gcc binutils make perl syslinux liblzma-dev"

WORKDIR /usr/src/ipxe-master
COPY ipxe /usr/src/ipxe-master/config/

RUN sed -i "s/%VLAN/${VLAN}/" /usr/src/ipxe-master/config/script.ipxe

RUN apt-get update && apt-get -y install $_ipxe_dependencies && \
    git clone https://github.com/ipxe/ipxe.git --depth=1 --single-branch /usr/src/ipxe-master/git/ && \
    mkdir -p /opt/ipxe && \
    mkdir git/src/config/local/custom && \
    cp config/custom.h git/src/config/local/custom && \
    cat config/custom.h >> git/src/config/general.h && \
    make -C git/src bin/ipxe.lkrn EMBED=../../config/script.ipxe && \
    cp git/src/bin/ipxe.lkrn  /opt/ipxe && \
    make -C git/src bin/undionly.kpxe EMBED=../../config/script.ipxe && \
    cp git/src/bin/undionly.kpxe /opt/ipxe && \
    make -C git/src bin-x86_64-efi/ipxe.efi EMBED=../../config/script.ipxe && \
    cp git/src/bin-x86_64-efi/ipxe.efi /opt/ipxe

CMD sleep 1d
