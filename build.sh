#!/bin/bash

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

    # Remove unnecessary files
    /bin/rm -v "${DST_DIR}/.buildinfo"
    /bin/rm -rv "${DST_DIR}/.doctrees"
    /bin/rm -v "${DST_DIR}/genindex.html"
    /bin/rm -v "${DST_DIR}/objects.inv"
    /bin/rm -rv "${DST_DIR}/_sources"
    /bin/rm -v "${DST_DIR}/_static/base-stemmer.js"
    /bin/rm -v "${DST_DIR}/_static/basic.css"
    /bin/rm -v "${DST_DIR}/_static/check-solid.svg"
    /bin/rm -v "${DST_DIR}/_static/copy-button.svg"
    /bin/rm -v "${DST_DIR}/_static/copybutton_funcs.js"
    /bin/rm -v "${DST_DIR}/_static/file.png"
    /bin/rm -v "${DST_DIR}/_static/french-stemmer.js"
    /bin/rm -v "${DST_DIR}/_static/minus.png"
    /bin/rm -v "${DST_DIR}/_static/translations.js"

    # Minify files
    python minify.py
}

if [ "${1}" == '--live' ]; then
    dev_live
else
    build_blog
fi
