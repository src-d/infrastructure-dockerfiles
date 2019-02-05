FROM google/cloud-sdk:183.0.0-alpine
COPY requirements.txt /tmp
RUN apk add --update python py-pip bash curl && \
  pip install -r /tmp/requirements.txt && \
  curl -L https://storage.googleapis.com/kubernetes-release/release/v1.8.7/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  apk del curl
ADD pvc-snapshot.sh /
ADD delete-snapshots.py /
