# Nœud Ξthereum local

Voyons comment mettre en place un nœud Ethereum local avec [Go Ethereum](https://geth.ethereum.org) (plus connu sous son nom raccourci : **Geth**).

## Installation

Il vous faudra un système d'exploitation sous GNU/Linux, puis :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 3-12
    :language: shell
```

## Comptes

Pour créer un compte, utilisez cette commande (sans mot de passe) :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 14
    :language: shell
```

````{hint}
Vous pouvez aussi importer un compte existant :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 15
    :language: shell
```
````

Un fichier *UTC--…* sera créé dans le dossier *dev/node/keystore*.
À partir de celui-ci, vous pouvez utiliser ce script Python pour récupérer la clef privée :

```{literalinclude} snippets/node-ethereum-locale.py
    :caption: dev/get-private-key.py
    :emphasize-lines: 14
    :language: python
```

À lancer tel que :

```{code-block} shell
python dev/get-private-key.py FILE
```

Où `FILE` est un des fichiers  *UTC--…* du dossier *dev/node/keystore*.

Pour la suite, admettons que nous ayons créé ce compte :

- adresse publique : `0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC`
- clef privée : `56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027`

## Initialisation

Créez le fichier qui servira à définir le bloc *genesis*.

La balance des comptes est à définir dans la section `alloc`.
Dans notre cas, le compte aura `1 000 000 $ETH`.

```{attention}
Les adresses ne doivent pas être préfixées de `0x`.
```

```{code-block} json
    :caption: dev/genesis.json
    :emphasize-lines: 33

{
    "config": {
        "chainId": 1234,
        "homesteadBlock": 0,
        "eip150Block": 0,
        "eip155Block": 0,
        "eip158Block": 0,
        "eip1559block": 0,
        "byzantiumBlock": 0,
        "constantinopleBlock": 0,
        "petersburgBlock": 0,
        "istanbulBlock": 0,
        "muirGlacierBlock": 0,
        "berlinBlock": 0,
        "londonBlock": 0,
        "arrowGlacierBlock": 0,
        "grayGlacierBlock": 0,
        "mergeNetsplitBlock": 0,
        "shanghaiTime": 0,
        "cancunTime": 0,
        "terminalTotalDifficulty": 0,
        "terminalTotalDifficultyPassed": true,
        "ethash": {}
    },
    "nonce": "0x0",
    "timestamp": "0x0",
    "extraData": "0x",
    "gasLimit": "0x23f3e20",
    "difficulty": "0x10000",
    "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x0000000000000000000000000000000000000000",
    "alloc": {
        "8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC": {
            "balance": "1000000000000000000000000"
        }
    },
    "number": "0x0",
    "gasUsed": "0x0",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "baseFeePerGas": null,
    "excessBlobGas": null,
    "blobGasUsed": null
}
```

Ensuite, lancez cette commande pour  (ou réinitialiser) le nœud :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 17-18
    :language: shell
```

## Démarrage

Démarrez le nœud (pensez à adapter l'adresse publique du compte) :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 20-34
    :emphasize-lines: 12-13,15
    :language: shell
```

```{note}
- `dev/account-pwd.txt` est un fichier qui contient le mot de passe (en l'occurrance, il est vide) ;
- `--httpi.api` : j'ai ajouté `net` pour faire plaisir à Metamask, mais sinon `eth,web3` suffit ;
- `--mine*`: requis pour la validation des transactions.
```

Détails de notre blockchain locale :

- RPC HTTP URL: `http://127.0.0.1:8545/`
- RPC WSS URL: `ws://127.0.0.1:8546`
- ChainID: `1234` (`0x4d2`)
- Symbol: `ETH`

Et voilà !

---

## 📜 Historique

2024-02-04
: Revue de l'article.
: Simplification du script Python pour récupérer la clef privée du compte.

2024-01-31
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2022/02/28/15/49/31-noeud-ethereum-local).
: Mise à jour de Geth (`1.10.17-25c9b49` → `1.13.11-8f7eb9cc`).

2022-04-21
: Activation du RPC WebSocket.

2022-03-01
: Mise à jour de Geth (`1.10.16-20356e57` → `1.10.17-25c9b49f`).

2022-02-28
: Premier jet.
