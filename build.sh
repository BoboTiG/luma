#!/bin/bash

SRC_DIR='sources'
DST_DIR='htdocs'

dev_live() {
    sphinx-autobuild \
        --host '0.0.0.0' \
        --open-browser \
        "${SRC_DIR}" \
        '_live'
}

build_blog() {
    sphinx-build \
        -d . \
        "${SRC_DIR}" \
        "${DST_DIR}"

}

[ "${1}" == 'live' ] && dev_live || build_blog
