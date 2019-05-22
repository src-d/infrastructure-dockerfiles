#!/bin/bash

set -e

# This script assumes we're in host network

function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Authenticating"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

log "Copying snapshot into $GCS_BUCKET"
gsutil cp "$SNAPSHOT" "gs://$GCS_BUCKET/$(basename $SNAPSHOT)"
