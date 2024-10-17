#!/bin/bash

export KOBO_ROOT="/media/${USERNAME}/KOBOeReader"
export KOBO_DIR="${KOBO_ROOT}/.kobo"
export KOBO_VERSION='4.37.21582'
export KOBO_PATCH_VERSION='82'
export KOBO_NM_VERSION='54'

dd bs=4M conv=sync,noerror status=progress \
    if='/dev/sdc' \
    of="kobo-$(date '+%Y%m%d')-full.dd"
cp -rv "${KOBO_DIR}" "${KOBO_DIR}-$(date '+%Y%m%d')"
sqlite3 "${KOBO_DIR}/KoboReader.sqlite" \
    'INSERT INTO user(UserID, UserKey) VALUES("1", "")'
sqlite3 "${KOBO_DIR}/KoboReader.sqlite" \
    'DELETE FROM content WHERE ___UserID != "adobe_user" ; VACUUM'
printf '[General]\naffiliate=Kobo\n' > "${KOBO_DIR}/affiliate.conf"

wget "https://ereaderfiles.kobo.com/firmwares/kobo7/Jun2024/kobo-update-${KOBO_VERSION}.zip" \
    && unzip "kobo-update-${KOBO_VERSION}.zip" -d "${KOBO_DIR}" \
    && sync

wget "https://github.com/pgaskin/kobopatch-patches/releases/download/v${KOBO_PATCH_VERSION}/kobopatch_${KOBO_VERSION}.zip" \
    && unzip "kobopatch_${KOBO_VERSION}.zip" \
    && cp -v "kobo-update-${KOBO_VERSION}.zip" 'src'
./kobopatch.sh \
    && cp -v 'out/KoboRoot.tgz' "${KOBO_DIR}" \
    && sync

wget "https://github.com/pgaskin/NickelMenu/releases/download/v${KOBO_NM_VERSION}/KoboRoot.tgz" \
        -O "${KOBO_DIR}/KoboRoot.tgz" \
    && sync

mkdir -pv "${KOBO_DIR}/custom-dict/" \
    && wget 'https://github.com/BoboTiG/ebook-reader-dict/releases/download/fr/dicthtml-fr-fr.zip' \
        -O "${KOBO_DIR}/custom-dict/" \
    && sync

wget 'http://ftp.gnu.org/gnu/freefont/freefont-ttf-20120503.zip' \
    && unzip 'freefont-ttf-20120503.zip' \
    && cd 'freefont-20120503' \
    && mv -v 'FreeSerif.ttf' 'FreeSerif-Regular.ttf' \
    && mv -v 'FreeSerifBold.ttf' 'FreeSerif-Bold.ttf' \
    && mv -v 'FreeSerifBoldItalic.ttf' 'FreeSerif-BoldItalic.ttf' \
    && mv -v 'FreeSerifItalic.ttf' 'FreeSerif-Italic.ttf' \
    && mkdir -pv "${KOBO_ROOT}/fonts" \
    && cp -v FreeSerif*.ttf "${KOBO_ROOT}/fonts" \
    && sync

patch --binary 'src/libnickel.so.1.0.0.yaml' 'libnickel.so.1.0.0.diff'
