# Python, Web3 : Décoder les logs d’un transfert

Prenons l’exemple d’un transfert sur le réseau [Avalanche Mainnet](https://www.avax.network) via le routeur [Trader Joe](https://lfj.gg/avalanche).
Comment savoir le nombre exact de *tokens* qui ont été transférés (envoyés et reçus) ?

Voici une solution, en prenant pour l’exemple [cette transaction](https://snowtrace.io/tx/0x5270f284b2a5432e264be7a173fd5f187983a86d80e7f65cf2e9125b7fde1e51) (⚠ ceci n’est pas mon portefeuille).

Imports et constantes :

```{literalinclude} snippets/web3py-decoder-logs-transfert.py
:lines: 1-26
:language: python
```

Récupération et décodage des *logs* :

```{literalinclude} snippets/web3py-decoder-logs-transfert.py
:lines: 28-38
:language: python
```

Enfin, quelques idées de traitement des *logs* :

```{literalinclude} snippets/web3py-decoder-logs-transfert.py
:lines: 40-53
:language: python
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

PS : J’avais partagé ces infos sur [cette issue](https://github.com/ethereum/web3.py/issues/1061#issuecomment-1049177039) en anglais.

## 📜 Historique

2024-01-27
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2022/02/23/21/24/20-python-web3-decoder-les-logs-dun-transfert).

2022-03-07
: Simplification du code : utilisation de `web3.logs.DISCARD` plutôt que de filtrer les avertissements.

2022-03-01
: Aération du code monolithique.

2022-02-25
: Prise en compte des transferts utilisant le *coin* de la *blockchain* (AVAX sur Avalanche, FTM sur Fantom, etc.).

2022-02-23
: Premier jet.
