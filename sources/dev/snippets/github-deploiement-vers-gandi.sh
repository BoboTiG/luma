#!/bin/bash

sudo apt install lftp

SFTP_URL='HOST'
SFTP_USER='USERNAME'
SFTP_PASSWORD='PASSWORD'
SFTP_PATH='/mnt/vhost/site/subfolder/'

mkdir -p ~/.ssh \
    && ssh-keyscan -H "${SFTP_URL}" >> ~/.ssh/known_hosts

lftp \
    -e "mirror --delete --transfer-all --reverse --verbose=1 ./FOLDER ${SFTP_PATH} ; quit" \
    -u "${SFTP_USER},${SFTP_PASSWORD}" \
    "sftp://${SFTP_URL}"
