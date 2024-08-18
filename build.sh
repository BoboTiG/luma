#!/bin/bash
set -eu

DST_DEV='_live'
DST_PROD='luma'
SRC_DIR='sources'

copy_audio_files() {
    local dest
    local folder

    dest="${1}"
    folder="${2}"
    mkdir -pv "${dest}/${folder}/audio"
    cp -rv "${SRC_DIR}/${folder}/audio/" "${dest}/${folder}/"
}

dev_live() {
    [ -d "${DST_DEV}" ] && /bin/rm -rv "${DST_DEV}"

    copy_audio_files "${DST_DEV}" 'inipi'

    python -m sphinx_autobuild \
        --host '0.0.0.0' \
        --open-browser \
        "${SRC_DIR}" \
        "${DST_DEV}"
}

build_blog() {
    [ -d "${DST_PROD}" ] && /bin/rm -rv "${DST_PROD}"

    copy_audio_files "${DST_PROD}" 'inipi'
    
    python -m sphinx \
        'build' \
        -E \
        --color \
        "${SRC_DIR}" \
        "${DST_PROD}"

    python minify.py
}

if [ "${1:-}" == '--live' ]; then
    dev_live
else
    build_blog
fi
