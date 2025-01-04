#!/bin/bash

sudo apt install lftp

FTP_URL='HOST'
FTP_USER='USERNAME'
FTP_PASSWORD='PASSWORD'

mkdir -p ~/.ssh \
    && ssh-keyscan -H "${FTP_URL}" >> ~/.ssh/known_hosts

lftp \
    -e "mirror --delete --transfer-all --reverse --verbose=1 ./FOLDER . ; quit" \
    -u "${FTP_USER},${FTP_PASSWORD}" \
    "ftp://${FTP_URL}"
