# Nœud Ethereum local

Voyons comment mettre en place un nœud Ethereum local avec [Go Ethereum](https://geth.ethereum.org). Il sera réellement local, c'est-à-dire qu'il ne s'agira pas d'un *fork* qui se synchronisera avec le réseau Ethereum.

## Installation

Il vous faudra un système d'exploitation sous GNU/Linux, puis :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 3-12
    :language: shell
```

## Comptes

Pour créer un compte, utilisez cette commande (sans mot de passe):

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 14-17
    :language: shell
```

Un fichier *UTC--…* sera créé dans le dossier *dev/node/keystore*.
À partir de celui-ci, vous pouvez utiliser ce script Python pour récupérer la clef privée :

```{literalinclude} snippets/node-ethereum-locale.py
    :caption: dev/get-private-key.py
    :language: python
```

À lancer tel que :

```{code-block} shell
python dev/get-private-key.py FILE
```

Où `FILE` est un des fichiers  *UTC--…* du dossier *dev/node/keystore*.

Pour la suite, admettons que nous ayons créé le compte ayant l'adresse `0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC` et la clef privée `56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027`.

## Initialisation

Créez le fichier qui servira à définir le bloc *genesis* :

```{code-block} json
    :caption: dev/genesis.json
    :emphasize-lines: 20

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
        "londonBlock": 0
    },
    "difficulty": "0x1",
    "gasLimit": "0xffffffffffff",
    "alloc": {
        "8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC": {
          "balance": "1000000000000000000000000"
        }
    }
}
```

La balance des comptes est à définir dans la section `alloc`. Notez que l'adresse ne doit pas être précédée de "0x".
Dans notre cas, le compte aura `1 000 000 $ETH`, je suis généreux ☻

Ensuite, lancez cette commande pour (ré)initialiser le nœud :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 18-19
    :language: shell
```

## Démarrage

Démarrez le nœud :

```{literalinclude} snippets/node-ethereum-locale.sh
    :lines: 21-36
    :emphasize-lines: 12
    :language: shell
```

Notes :

- *dev/account-pwd.txt* est un fichier vide, étant donné que je n'ai pas défini de mot de passe à la création du compte. Sinon, il devrait contenir le mot de passe.
- `--httpi.api` : j'ai ajouté `net` pour faire plaisir à Metamask, mais sinon `eth,web3` suffit.
- `--mine*`: requis pour la validation des transactions.

Détails de notre blockchain locale :

- RPC HTTP URL: `http://127.0.0.1:8545/`
- RPC WSS URL: `ws://127.0.0.1:8546`
- ChainID: `1234` (`0x4d2`)
- Symbol: `ETH`

Et voilà !

---

## 📜 Historique

2024-01-31
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2022/02/28/15/49/31-noeud-ethereum-local).
: Mise à jour de Geth (`1.10.17-25c9b49` → `1.13.11-8f7eb9cc`).

2022-04-21
: Activation du RPC WebSocket.

2022-03-01
: Mise à jour de Geth (`1.10.16-20356e57` → `1.10.17-25c9b49f`).

2022-02-28
: Premier jet.
