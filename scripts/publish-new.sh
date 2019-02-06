#!/bin/bash

CHANGED_VERSIONS=$(git diff --name-only $TRAVIS_COMMIT_RANGE | grep 'VERSION$')
WORKDIR=$(pwd)
while read -r line; do
    if [[ "$line" == "" ]]; then
        continue
    fi
    DIR=$(dirname "$line")
    cd "$DIR" || continue
    echo "Building and pushing $DIR"
    make docker-login
    #make docker-push
    cd $WORKDIR
done <<< "$CHANGED_VERSIONS"
