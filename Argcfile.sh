#!/usr/bin/env bash

set -e

# @cmd
build() {
    if [ -d "build/" ]; then
        rm -rf ./build
    fi
    mkdir build
    argc --argc-mangen bbcp.sh build
    argc --argc-build bbcp.sh build
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
