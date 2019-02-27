#!/bin/bash

set -e
set -o pipefail

[[ "$TRACE" ]] && set -x

function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

count=0
for var in HOSTNAME \
           USERNAME \
           PASSWORD \
           DATABASE \
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

PORT=${PORT:-5432}
JOBS=${JOBS:-4}
DUMP_DIR="$TEMP_DIR/postgres-$DATABASE-dump-$(date +%Y%m%d%H%M%S)"
PGPASSFILE="$TEMP_DIR/.pgpass"

trap "rm -rf $DUMP_DIR $PGPASSFILE" EXIT

log "Creating postgres backup of $DATABASE"
echo "$HOSTNAME:$PORT:$DATABASE:$USERNAME:$PASSWORD" > "$PGPASSFILE"
chmod 600 "$PGPASSFILE"
export PGPASSFILE
pg_dump --no-password \
        --jobs="$JOBS" \
        --host="$HOSTNAME" \
        --port="$PORT" \
        --username="$USERNAME" \
        --format=d \
        --dbname="$DATABASE" \
        --file="$DUMP_DIR"

log "Authenticating in Goggle Cloud"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

log "Copying snapshot into $GCS_BUCKET"
gsutil cp -r "$DUMP_DIR" "gs://$GCS_BUCKET/$(basename $DUMP_DIR)"
