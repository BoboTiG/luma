#!/bin/bash
set -eu

SRC_DIR='sources'
DST_DIR='luma'

dev_live() {
    [ -d '_live' ] && /bin/rm -rv '_live'

    python -m sphinx_autobuild \
        --host '0.0.0.0' \
        --open-browser \
        "${SRC_DIR}" \
        '_live'
}

build_blog() {
    [ -d "${DST_DIR}" ] && /bin/rm -rv "${DST_DIR}"

    python -m sphinx \
        'build' \
        -E \
        --color \
        "${SRC_DIR}" \
        "${DST_DIR}"

    python minify.py
}

if [ "${1:-}" == '--live' ]; then
    dev_live
else
    build_blog
fi
