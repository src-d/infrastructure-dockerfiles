#!/bin/bash

set -e

# This script assumes we're in host network

function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

count=0
for var in ETCD_ENDPOINTS \
           ETCD_CLIENT_CA_CERT \
           ETCD_CLIENT_CERT \
           ETCD_CLIENT_KEY \
           GCS_BUCKET \
           GOOGLE_APPLICATION_CREDENTIALS \
           TEMP_DIR
do
    if [[ ! "${!var}" ]]; then
        log "${var} not set"
        count=$((count + 1))
    fi
done

[[ $count -gt 0 ]] && exit 1

for var in ETCD_CLIENT_CA_CERT ETCD_CLIENT_CERT ETCD_CLIENT_KEY; do
    echo "${!var}" | base64 -d > "$TEMP_DIR/$var"
done

export ETCDCTL_API=3
ETCDCTL="etcdctl --endpoints $ETCD_ENDPOINTS --cacert $TEMP_DIR/ETCD_CLIENT_CA_CERT --cert $TEMP_DIR/ETCD_CLIENT_CERT --key $TEMP_DIR/ETCD_CLIENT_KEY"

SNAPSHOT="$TEMP_DIR/etcd-backup-$(date +%Y%m%d%H%M%S).db"

log "Creating etcd snapshot"
$ETCDCTL snapshot save "$SNAPSHOT"

log "Verifying etcd snapshot"
$ETCDCTL snapshot status "$SNAPSHOT"

log "Authenticating"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

log "Copying snapshot into $GCS_BUCKET"
gsutil cp "$SNAPSHOT" "gs://$GCS_BUCKET/$(basename $SNAPSHOT)"
