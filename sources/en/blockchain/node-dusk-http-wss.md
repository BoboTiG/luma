# How to query your Dusk node?

```{figure} ../../blockchain/images/dusk-logo.svg
:width: 96
:height: 96
:alt: Dusk Logo
:align: center

Website: [dusk.network](https://dusk.network)
```

Here are several ways to query your Dusk node: [GraphQL](#graphql), [RPC](#rpc), and [RUES](#rues).

````{tip}
🇫🇷 French version: [Communiquer avec votre nœud Dusk](../../blockchain/node-dusk-http-wss.md).

```{code-block}
:caption: 🫶 Dusk wallet for tips
VKZpBrNtEeTobMgYkkdcGiZn8fK2Ve2yez429yRXrH4nUUDTuvr7Tv74xFA2DKNVegtF6jaom2uacZMm8Z2Lg2J
```
````

## 1️⃣ GraphQL

### Overview of all available GraphQL functions and their data structures

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 286
:language: shell
```

### Fetch the latest block height

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 4-5
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 7-13
:language: json
```

### Fetch latest N blocks

Instead of retreiving too much information, here we only want the block height (`height`), and the provisioner address (`generatorBlsPubkey`) that validated the block.

You can tweak the blocks count at the line `last: 100` (latest 100 blocks for instance).

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 18-20
:emphasize-lines: 3
:language: shell
```

Same as above, but using a special HTTP header to pass the number of blocks to fetch as a variable: [`rusk-gqlvar-XXX`](https://github.com/dusk-network/rusk/blob/2db27ecdd9614605ca2fd83a5a7370a0d0900706/rusk/src/lib/http/chain.rs#L35) (where `XXX` is the vairable name).

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 22-26
:emphasize-lines: 2,5
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 28-44
:language: json
```

### Fetch latest N blocks with transaction data

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 48-51
:emphasize-lines: 4
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 53-75
:language: json
```

### Fetch latest N blocks with JSON transaction data

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 81-84
:emphasize-lines: 4
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 86-103
:language: json
```

And parsing the JSON data:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 107-126
:language: json
```

### Fetch a range of blocks

Example with blocks 10, 11, and 12: the syntax is `[10, 12]`.

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 149-151
:emphasize-lines: 3
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 153-174
:language: json
```

### Fetch JSON transaction details of a given block

Lets get the block height 189314.

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 130-133
:emphasize-lines: 4
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 135-145
:language: json
```

### Fetch block, and transaction, details of a given block

Lets get the block height 189314.

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 198-201
:emphasize-lines: 4
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 203-244
:language: json
```

### Fetch full history for a given address

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 289-290
:emphasize-lines: 2
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 292-325
:language: json
```

### Fetch Account Balance & Nonce

```{versionadded} 1.0.2
```

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 329
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 331-334
:language: json
```

## 2️⃣ RPC

### Get the list of all provisioners

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 178
:language: shell
```

Output example:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 180-194
:language: json
```

## 3️⃣ RUES

[RUES](https://docs.dusk.network/developer/integrations/rues/) for *Rusk Universal Event System* is a mechanism for handling real-time communication with an event-driven approach.

This is some Python code, and you will need to install [requests](https://pypi.org/project/requests/), and [websockets](https://pypi.org/project/websockets/), modules first.

### Look for generated blocks of a given provisioner

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.py
:caption: File: listen.py
:language: python
```

When the script is running, block heights generated by the provisioner will be printed in real-time:

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 247
:language: shell
```

Output example of the raw response (it is the `raw` variable in the script) :

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 249
```

And when parsed, this JSON object is made available (it is the `block` variable in the script) :

```{literalinclude} ../../blockchain/snippets/node-dusk-http-wss.sh
:lines: 250-282
:language: json
```

## 📜 Changelog

2025-02-14
: Add the GraphQL section [Fetch Account Balance & Nonce](#fetch-account-balance-nonce) (rusk [`1.0.2`](https://github.com/dusk-network/rusk/releases/tag/dusk-rusk-1.1.0)).

2025-02-03
: Prefer using the `--json` argument for `curl` calls instead of `--data-raw`.

2025-01-30
: Add the GraphQL section [Overview of all available GraphQL functions and their data structures](#overview-of-all-available-graphql-functions-and-their-data-structures).
: Add the GraphQL section [Fetch full history for a given address](#fetch-full-history-for-a-given-address).

2025-01-29
: First draft.
