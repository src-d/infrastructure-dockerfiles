FROM google/cloud-sdk:226.0.0-alpine
ENV ETCD_VERSION=v3.3.8
RUN apk add --no-cache curl bash
RUN \
  cd /tmp && \
  curl -L https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz | \
    tar -xz -C /usr/local/bin --strip-components=1 -f - etcd-${ETCD_VERSION}-linux-amd64/etcdctl && \
  apk del curl
ADD do-backup.sh /usr/local/bin
