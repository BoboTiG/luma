#!/bin/bash

sudo apt install lftp

FTP_URL='HOST'
FTP_USER='USERNAME'
FTP_PASSWORD='PASSWORD'

lftp \
    -e 'set ssl:verify-certificate false ; mirror --delete --transfer-all --reverse --verbose=1 ./FOLDER . ; quit' \
    -u "${FTP_USER},${FTP_PASSWORD}" \
    "ftp://${FTP_URL}"
