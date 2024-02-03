#!/bin/bash

SRC_DIR='sources'
DST_DIR='luma'

dev_live() {
    sphinx-autobuild \
        --host '0.0.0.0' \
        --open-browser \
        "${SRC_DIR}" \
        '_live'
}

build_blog() {
    [ -d "${DST_DIR}" ] && /bin/rm -rv "${DST_DIR}"

    sphinx-build \
        -E \
        --color \
        "${SRC_DIR}" \
        "${DST_DIR}"

    # Remove unnecessary files
    /bin/rm -v "${DST_DIR}/.buildinfo"
    /bin/rm -rv "${DST_DIR}/.doctrees"
    /bin/rm -v "${DST_DIR}/genindex.html"
    /bin/rm -v "${DST_DIR}/objects.inv"
    /bin/rm -rv "${DST_DIR}/_sources"
}

[ "${1}" == 'live' ] && dev_live || build_blog
