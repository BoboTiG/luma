#!/bin/bash

GETH_VERSION='1.13.11-8f7eb9cc'
GETH_FOLDER="geth-linux-amd64-${GETH_VERSION}"

wget "https://gethstore.blob.core.windows.net/builds/${GETH_FOLDER}.tar.gz" \
    && tar -xzf "${GETH_FOLDER}.tar.gz" --transform 's/-linux-amd64-.*//' \
    && mkdir -p ~/.local/bin \
    && mv 'geth' ~/.local/bin/ \
    && rm "${GETH_FOLDER}.tar.gz" \
    && mkdir -p 'dev/node' \
    && hash

geth --datadir 'dev/node' account new
geth --datadir 'dev/node' account import 'UTC--…'

rm -rf 'dev/node/geth' \
    && geth --datadir 'dev/node' init 'dev/genesis.json'

geth \
    --datadir 'dev/node' \
    --ipcdisable \
    --http \
    --http.api 'eth,net,web3' \
    --http.corsdomain '*' \
    --ws \
    --ws.api='eth,web3' \
    --ws.origins='*' \
    --nodiscover \
    --allow-insecure-unlock \
    --unlock '0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC' \
    --password 'dev/account-pwd.txt' \
    --mine \
    --miner.etherbase '0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC'
