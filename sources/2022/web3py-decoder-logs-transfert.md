# Python, web3 : Décoder les logs d'un transfert

Prenons l'exemple d'un transfert sur le réseau [Avalanche Mainnet](https://www.avax.network) via le routeur [Trader Joe](https://traderjoexyz.com/).
Comment savoir le nombre exact de *tokens* qui ont été transférés (envoyés et reçus) ?

Voici une solution, en prenant pour l'exemple [cette transaction](https://snowtrace.io/tx/0x5270f284b2a5432e264be7a173fd5f187983a86d80e7f65cf2e9125b7fde1e51) (⚠ ceci n'est pas mon portefeuille).

Imports et constantes :

```{code-block} python
from web3 import HTTPProvider, Web3
from web3.logs import DISCARD

# Note: I picked a random transaction, this is not my wallet!
MY_ADDRESS = "0xDA9f28a1b0CE18b011A404f3372d98C3E3143569"
TX_HASH = "0x5270f284b2a5432e264be7a173fd5f187983a86d80e7f65cf2e9125b7fde1e51"

AVALANCHE_MAINNET_RPC_URL = "https://api.avax.network/ext/bc/C/rpc"
TRADER_JOE_ROUTER_ADDRESS = "0x60aE616a2155Ee3d9A68541Ba4544862310933d4"

# We will check both wallet, and router, addresses to catch coins transfers too (USDC.e -> AVAX for example)
ADDRESSES = {MY_ADDRESS, TRADER_JOE_ROUTER_ADDRESS}

MINIMAL_ABI = [
    # Transfer event
    {
        "name": "Transfer",
        "type": "event",
        "anonymous": False,
        "inputs": [
            {"indexed": True, "name": "from", "type": "address"},
            {"indexed": True "name": "to", "type": "address"},
            {"indexed": False, "name": "value", "type": "uint256"},
        ],
    },
]
```

Récupération et décodage des *logs* :

```{code-block} python
# Initiate the machine
w3 = Web3(HTTPProvider(AVALANCHE_MAINNET_RPC_URL))

# Instantiate the router
router = w3.eth.contract(address=TRADER_JOE_ROUTER_ADDRESS, abi=MINIMAL_ABI)

# Get the transaction receipt
receipt = w3.eth.get_transaction_receipt(TX_HASH)

# Decode logs, without displaying warnings about discarded logs
logs = router.events.Transfer().processReceipt(receipt, errors=DISCARD)
```

Enfin, quelques idées de traitement des *logs* :

```{code-block} python
# 1. Access details as simply as:
print("Details:")
for idx, log in enumerate(logs, start=1):
    args = log.args
    print(f"  {idx}. From {args['from']} to {args['to']} for {args['value']} tokens")

# 2. Or compute amounts
tokens_sent = sum(log.args["value"] for log in logs if log.args["from"] in ADDRESSES)
tokens_received = sum(log.args["value"] for log in logs if log.args["to"] in ADDRESSES)

# You will need to adapt "10**N" with the real token decimals
print("\nAmounts:")
print(f"  - Tokens sent    : {tokens_sent / 10**18:.5f} $WETH.e")
print(f"  - Tokens received: {tokens_received / 10**9:.5f} $TIME")
```

Pour la démonstration, voici ce qui sera affiché :

```{code-block} text
Details:
  1. From 0xDA9f28a1b0CE18b011A404f3372d98C3E3143569 to 0xFE15c2695F1F920da45C30AAE47d11dE51007AF9 for 984378414134985971 tokens
  2. From 0xFE15c2695F1F920da45C30AAE47d11dE51007AF9 to 0xf64e1c5B6E17031f5504481Ac8145F4c3eab4917 for 59247645014580674712 tokens
  3. From 0xf64e1c5B6E17031f5504481Ac8145F4c3eab4917 to 0xDA9f28a1b0CE18b011A404f3372d98C3E3143569 for 480492703 tokens

Amounts:
  - Tokens sent    : 0.98438 $WETH.e
  - Tokens received: 0.48049 $TIME
```

Et voilà !

PS : J'avais partagé ces infos sur [cette issue](https://github.com/ethereum/web3.py/issues/1061#issuecomment-1049177039) en anglais.

---

## Historique

- 2024-01-27 : Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2022/02/23/21/24/20-python-web3-decoder-les-logs-dun-transfert).
- 2022-03-07 : Simplification du code : utilisation de `web3.logs.DISCARD` plutôt que de filtrer les avertissements.
- 2022-03-01 : Aération du code monolithique.
- 2022-02-25 : Prise en compte des transferts utilisant le *coin* de la *blockchain* (AVAX sur Avalanche, FTM sur Fantom, etc.).
- 2022-02-23 : Premier jet.