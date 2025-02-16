#!/usr/bin/env bash
# @meta require-tools pandoc

set -e

# @cmd Generate docs and rmeove argc dependency
build() {
    if [ -d "build/" ]; then
        rm -rf ./build
    fi
    mkdir build
    pandoc -s ./bbcp.1.md -o ./build/bbcp.1
    argc --argc-build bbcp.sh build
}

# @cmd Package project for release
package() {
    build
    cd build
    tar czf bbcp.tar.gz *
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
