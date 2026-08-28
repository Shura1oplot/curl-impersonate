#!/usr/bin/env bash

set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly REPO_DIR
readonly BUILD_DIR=$REPO_DIR/build-cli
readonly INSTALL_DIR=$HOME/.local

MAKE_CMD=$(command -v make)

if command -v gmake &>/dev/null; then
    MAKE_CMD=$(command -v gmake)
fi

readonly MAKE_CMD
readonly CMAKE_CONFIGURE_ARGS="-G Ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DCURL_IMPERSONATE_ENV_HOOK=ON"

cd "$REPO_DIR"
git pull --ff-only

if [[ $(uname -s) == Linux ]]; then
    "$MAKE_CMD" prepare-libidn2 \
        BUILD_DIR="$BUILD_DIR"
fi

"$MAKE_CMD" build \
    BUILD_DIR="$BUILD_DIR" \
    CMAKE_CONFIGURE_ARGS="$CMAKE_CONFIGURE_ARGS"
"$MAKE_CMD" checkbuild \
    BUILD_DIR="$BUILD_DIR"
"$MAKE_CMD" install-strip \
    BUILD_DIR="$BUILD_DIR" \
    CMAKE_CONFIGURE_ARGS="$CMAKE_CONFIGURE_ARGS" \
    CMAKE_INSTALL_ARGS="--prefix $INSTALL_DIR"
