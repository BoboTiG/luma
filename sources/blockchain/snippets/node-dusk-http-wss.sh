#!/bin/bash

# Fetch the latest block height
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
   'query { block(height: -1) { header { height } } }'
cat << 'EOF'
{
    "block": {
        "header": {
            "height": 189268
        }
    }
}
EOF

# Fetch latest N blocks (here: 100 blocks, and only the bloc height, and provisioner)
# You can find more retreivable data from `BlockInfo`: https://github.com/dusk-network/rusk/blob/835bc6f57d3f1edb06f45266b9005018772b0561/explorer/src/lib/services/gql-queries.js#L27
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
   'fragment BlockInfo on Block { header { height, generatorBlsPubkey } }
    query() { blocks(last: 100) {...BlockInfo} }'
# Same as above, but using HTTP headers to pass the number of blocks to fetch as a variable
curl 'https://nodes.dusk.network/on/graphql/query' \
    -H 'rusk-gqlvar-count: 100' \
    --data-raw \
        'fragment BlockInfo on Block { header { height, generatorBlsPubkey } }
         query($count: Int!) { blocks(last: $count) {...BlockInfo} }'
cat << 'EOF'
{
    "blocks": [
        {
            "header": {
                "generatorBlsPubkey": "xY8e71u5E8CFmSU1...",
                "height": 189291
            }
        },
        {
            "header": {
                "generatorBlsPubkey": "ueu27WiUjcssYMvR...",
                "height": 189290
            }
        },
        // (...)
    ]
}
EOF

# Fetch latest 100 blocks (include the height, provisioner, and transactions data)
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
   'fragment TransactionInfo on SpentTransaction { tx { callData { contractId, data, fnName }, txType }}
    fragment BlockInfo on Block { header { height, generatorBlsPubkey }, transactions {...TransactionInfo} }
    query() { blocks(last: 100) {...BlockInfo} }'
cat << 'EOF'
{
    "blocks": [
        // (...)
        {
            "header": {
                "generatorBlsPubkey": "24e5SaodhsLnTpHW...",
                "height": 189314
            },
            "transactions": [
                {
                    "tx": {
                        "callData": {
                            "contractId": "0200000000000000000000000000000000000000000000000000000000000000",
                            "data": "0000000000000000b574dad75d051d3993fb9ba7c36453ca9c10d63fc48b0d924144d...",
                            "fnName": "stake"
                        },
                        "txType": "Moonlight"
                    }
                }
            ]
        },
        // (...)
    ]
}
EOF


# Same as above, but get a JSON serialization of transactions data
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
   'fragment TransactionInfo on SpentTransaction { tx { json } }
    fragment BlockInfo on Block { header { height, generatorBlsPubkey }, transactions {...TransactionInfo} }
    query() { blocks(last: 100) {...BlockInfo} }'
cat << 'EOF'
{
    "blocks": [
        // (...)
        {
            "header": {
                "generatorBlsPubkey": "24e5SaodhsLnTpHW...",
                "height": 189314
            },
            "transactions": [
                {
                    "tx": {
                        "json": "{\"type\":\"moonlight\",\"sender\":\"21SvzTdXggQkZpnk...\",\"receiver\":null,\"value\":0,\"nonce\":35,\"deposit\":1070000000000,\"fee\":{\"gas_price\":\"1\",\"refund_address\":\"21SvzTdXggQkZpnk...\",\"gas_limit\":\"2000000000\"},\"call\":{\"contract\":\"0200000000000000000000000000000000000000000000000000000000000000\",\"fn_name\":\"stake\",\"fn_args\":\"AAAAAAAAAAC1dNrXXQUdOZP7m6fDZFPKnBDWP8SLDZJBRN2nzm4EPSMTh16bHMpQU\"},\"is_deploy\":false,\"memo\":null}"
                    }
                }
            ]
        },
        // (...)
    ]
}
EOF
cat << 'EOF'
{
    "call": {
        "contract": "0200000000000000000000000000000000000000000000000000000000000000",
        "fn_args": "AAAAAAAAAAC1dNrXXQUdOZP7m6fDZFPKnBDWP8SLDZJBRN2nzm4EPSMTh16bHMpQU...",
        "fn_name": "stake"
    },
    "deposit": 1070000000000,
    "fee": {
        "gas_limit": "2000000000",
        "gas_price": "1",
        "refund_address": "21SvzTdXggQkZpnk..."
    },
    "is_deploy": false,
    "memo": null,
    "nonce": 35,
    "receiver": null,
    "sender": "21SvzTdXggQkZpnk...",
    "type": "moonlight",
    "value": 0
}
EOF

# Fetch transaction details on a given block
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
   'fragment TransactionInfo on SpentTransaction { tx { json } }
    fragment BlockInfo on Block { transactions {...TransactionInfo} }
    query() { block(height: 189314) {...BlockInfo} }'
cat << 'EOF'
{
    "block": {
        "transactions": [
            {
                "tx": {
                    "json": "{\"type\":\"moonlight\",\"sender\":\"21SvzTdXggQkZpnk...\",\"receiver\":null,\"value\":0,\"nonce\":35,\"deposit\":1070000000000,\"fee\":{\"gas_price\":\"1\",\"refund_address\":\"21SvzTdXggQkZpnk...\",\"gas_limit\":\"2000000000\"},\"call\":{\"contract\":\"0200000000000000000000000000000000000000000000000000000000000000\",\"fn_name\":\"stake\",\"fn_args\":\"AAAAAAAAAAC1dNrXXQUdOZP7m6fDZFPKnBDWP8SLDZJBRN2nzm4EPSMTh16bHMpQU\"},\"is_deploy\":false,\"memo\":null}"
                }
            }
        ]
    }
}
EOF

# Fetch a range of blocks (here, from blocks at height 10 until 12)
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
   'fragment BlockInfo on Block { header { height, generatorBlsPubkey } }
    query() { blocks(range: [10, 12]) {...BlockInfo} }'
cat << 'EOF'
{
    "blocks": [
        {
            "header": {
                "generatorBlsPubkey": "25hxg2DMEmj1ghG8...",
                "height": 10
            }
        },
        {
            "header": {
                "generatorBlsPubkey": "od2bVPYstYud4N1G...",
                "height": 11
            }
        },
        {
            "header": {
                "generatorBlsPubkey": "nw2fQCAYb5S5v9eM...",
                "height": 12
            }
        }
    ]
}
EOF

# Get the list of all provisioners
curl 'https://nodes.dusk.network/on/node/provisioners' -X POST
cat << 'EOF'
[
    {
        "amount": 37000000000000,
        "eligibility": 4320,
        "faults": 0,
        "hard_faults": 0,
        "key": "mAkcDzY2uVvqbEv6...",
        "locked_amt": 0,
        "owner": {
            "Account": "mAkcDzY2uVvqbEv6..."
        },
        "reward": 924095468388
    },
    // (...)
]
EOF

# Fetch full block, and transaction, details on a given block
curl 'https://nodes.dusk.network/on/graphql/query' --data-raw \
    'fragment TransactionInfo on SpentTransaction { blockHash, blockHeight, blockTimestamp, err, gasSpent, id, tx { callData { contractId, data, fnName }, gasLimit, gasPrice, id, isDeploy, json, memo, txType } }
     fragment BlockInfo on Block { header { hash, gasLimit, height, generatorBlsPubkey, prevBlockHash, seed, stateHash, timestamp, version }, fees, gasSpent, reward, transactions {...TransactionInfo} }
     query() { block(height: 189314) {...BlockInfo} }'
cat << 'EOF'
{
    "block": {
        "fees": 25973789,
        "gasSpent": 25973789,
        "header": {
            "gasLimit": 3000000000,
            "generatorBlsPubkey": "24e5SaodhsLnTpHW...",
            "hash": "332799ed787002e6619f0f3c4f6b7fa05333881f50c5cf2f23fba35b80e734f7",
            "height": 189314,
            "prevBlockHash": "b75f26bff0c0e8e624b8d1a4b2345bd97a032e47834cb4c9625f546a37626796",
            "seed": "923e8f3196ea3be10bad98d2d322f6cbfd7e8a6732d804615929561a660cea49406f795589a86a8d400d4b6f5418aa69",
            "stateHash": "37150543eb1e6c3457f3219ee4535e4534eec7dbc118cae32d4b5ca3e90444c4",
            "timestamp": 1738145108,
            "version": 1
        },
        "reward": 19857400000,
        "transactions": [
            {
                "blockHash": "332799ed787002e6619f0f3c4f6b7fa05333881f50c5cf2f23fba35b80e734f7",
                "blockHeight": 189314,
                "blockTimestamp": 1738145108,
                "err": null,
                "gasSpent": 25973789,
                "id": "bc52d0247c70dde8707d8f49f5d656a9272962cc2e0dc3ca2192e6e117b40d59",
                "tx": {
                    "callData": {
                        "contractId": "0200000000000000000000000000000000000000000000000000000000000000",
                        "data": "0000000000000000b574dad75d051d3993fb9ba7c36453ca9c10d63fc48b0d924144dd...",
                        "fnName": "stake"
                    },
                    "gasLimit": 2000000000,
                    "gasPrice": 1,
                    "id": "bc52d0247c70dde8707d8f49f5d656a9272962cc2e0dc3ca2192e6e117b40d59",
                    "isDeploy": false,
                    "json": "{\"type\":\"moonlight\",\"sender\":\"21SvzTdXggQkZpnk...\",\"receiver\":null,\"value\":0,\"nonce\":35,\"deposit\":1070000000000,\"fee\":{\"gas_price\":\"1\",\"gas_limit\":\"2000000000\",\"refund_address\":\"21SvzTdXggQkZpnk...\"},\"call\":{\"fn_args\":\"AAAAAAAAAAC1dNrXXQUdOZP7m6fDZFPKnBDWP8SLDZJBRN2nzm4EPSMTh16bHMpQU...\",\"contract\":\"0200000000000000000000000000000000000000000000000000000000000000\",\"fn_name\":\"stake\"},\"is_deploy\":false,\"memo\":null}",
                    "memo": null,
                    "txType": "Moonlight"
                }
            }
        ]
    }
}
EOF

python listen.py 'PROVISIONER_PUBLIC_KEY'
cat << 'EOF'
b'k\x00\x00\x00{"Content-Location":"/on/blocks:a9e42d231967df49dba9ab1fdf5d40d68287c3af715b53cff841c7a8703bf6d2/accepted"}{"header":{"event_bloom":"000...","failed_iterations":[],"faultroot":"000...","gas_limit":3000000000,"generator_bls_pubkey":"22JbHtrL93fhFDvY...","hash":"a9e...","height":191574,"iteration":0,"prev_block_cert":{"ratification":{"aggregate_signature":"ac5...","bitset":106597789095414875},"result":{"Valid":"7e1..."},"validation":{"aggregate_signature":"844...","bitset":2232142576123535}},"prev_block_hash":"7e1...","seed":"942...","signature":"a32...","state_hash":"be8...","timestamp":1738167716,"txroot":"000...","version":1},"transactions":[]}'
{
    "header": {
        "event_bloom": "000...",
        "failed_iterations": [],
        "faultroot": "000...",
        "gas_limit": 3000000000,
        "generator_bls_pubkey": "22JbHtrL93fhFDvY...",
        "hash": "a9e...",
        "height": 191574,
        "iteration": 0,
        "prev_block_cert": {
            "ratification": {
                "aggregate_signature": "ac5...",
                "bitset": 106597789095414875
            },
            "result": {
                "Valid": "7e1..."
            },
            "validation": {
                "aggregate_signature": "844...",
                "bitset": 2232142576123535
            }
        },
        "prev_block_hash": "7e1...",
        "seed": "942...",
        "signature": "a32...",
        "state_hash": "be8...",
        "timestamp": 1738167716,
        "txroot": "000...",
        "version": 1
    },
    "transactions": []
}
EOF
