#!/bin/bash

set -e

CHANGED_FILES=$(mktemp)
trap "rm -f $CHANGED_FILES" EXIT

git diff --name-only "$TRAVIS_COMMIT_RANGE" > "$CHANGED_FILES"

grep 'VERSION$' "$CHANGED_FILES" || { echo "No VERSION files changed. Exiting."; exit 0; }

WORKDIR=$(pwd)
grep 'VERSION$' "$CHANGED_FILES" | while read line; do
    if [[ "$line" == "" ]]; then
        continue
    fi
    DIR=$(dirname "$line")
    cd "$DIR" || continue
    echo "Building and pushing $DIR"
    make docker-login
    make docker-push
    cd $WORKDIR
done
