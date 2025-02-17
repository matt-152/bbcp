#!/usr/bin/env bash
# @meta require-tools pandoc,sudo,tar,install

set -e

INSTALL_PATH="/usr/local/bin/bbcp"
INSTALL_MAN_PATH="/usr/local/share/man/man1/bbcp.1"

# @cmd
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

# @cmd
install() {
    build
    echo "Installing. Password may be necessary"
    sudo install -m 755 build/bbcp.sh "$INSTALL_PATH"
    sudo install -m 644 build/bbcp.1 "$INSTALL_MAN_PATH"
}

# @cmd
uninstall() {
    echo "Uninstalling. Password may be necessary"
    sudo rm "$INSTALL_PATH"
    sudo rm "$INSTALL_MAN_PATH"
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
