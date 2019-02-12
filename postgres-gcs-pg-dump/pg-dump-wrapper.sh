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
DUMP_FILE="$TEMP_DIR/postgres-$DATABASE-dump-$(date +%Y%m%d%H%M%S).sqlc.gz"

log "Creating postgres backup of $DATABASE"
export PGPASSFILE="$TEMP_DIR/.pgpass"
echo "$HOSTNAME:$PORT:$DATABASE:$USERNAME:$PASSWORD" > "$PGPASSFILE"
chmod 600 "$PGPASSFILE"
pg_dump --no-password --host="$HOSTNAME" --username="$USERNAME" --format=c --dbname="$DATABASE" | gzip > "$DUMP_FILE"

log "Authenticating"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

log "Copying snapshot into $GCS_BUCKET"
gsutil cp "$DUMP_FILE" "gs://$GCS_BUCKET/$(basename $DUMP_FILE)"
