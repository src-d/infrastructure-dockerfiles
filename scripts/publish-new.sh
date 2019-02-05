#!/bin/bash

CHANGED_VERSIONS=$(git diff --name-only $TRAVIS_COMMIT_RANGE | grep 'VERSION$')
WORKDIR=$(pwd)
while read -r line; do
    DIR=$(dirname "$line")
    cd $DIR
    echo "Building and pushing $DIR"
    make docker-login
    make docker-push
    cd $WORKDIR
done <<< "$CHANGED_VERSIONS"
