#!/bin/sh
branch=${2:-'master'}
COMMIT=$(git rev-list $branch | tail -n $1 | head -n 1)
git checkout $COMMIT
