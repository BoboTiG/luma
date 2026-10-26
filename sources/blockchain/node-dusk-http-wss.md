# Communiquer avec votre nœud Dusk

<!-- pyml disable link-fragments -->
```{figure} images/dusk-logo.svg
:width: 96
:height: 96
:alt: Dusk Logo
:align: center

Site web : [dusk.network](https://dusk.network)
```

Voici différentes manières de questionner votre nœud Dusk : [GraphQL](#graphql), [RPC](#rpc) et [RUES](#rues).

````{tip}
🇬🇧 Version anglaise : [How to query your Dusk node?](../en/blockchain/node-dusk-http-wss.md)

```{code-block}
:caption: 🫶 Adresse Dusk pour les pourboires
VKZpBrNtEeTobMgYkkdcGiZn8fK2Ve2yez429yRXrH4nUUDTuvr7Tv74xFA2DKNVegtF6jaom2uacZMm8Z2Lg2J
```
````

## 1️⃣ GraphQL

### Lister les fonctions GraphQL disponibles et leurs structures de données

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 286
:language: shell
```

### Récupérer le dernier numéro de bloc

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 4-5
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 7-13
:language: json
```

### Récupérer les N derniers blocs

Plutôt que de récupérer trop d’informations, ici, nous ne voulons que le numéro du bloc (`height`) et l’adresse du nœud (`generatorBlsPubkey`) qui l’a validé.

Vous pouvez modifier le nombre de blocs à la ligne `last: 100` (pour les 100 derniers blocs, par exemple).

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 18-20
:emphasize-lines: 3
:language: shell
```

Le même type de requête peut être effectué en spécifiant le nombre de blocs dans un entête HTTP spécial [`rusk-gqlvar-XXX`](https://github.com/dusk-network/rusk/blob/2db27ecdd9614605ca2fd83a5a7370a0d0900706/rusk/src/lib/http/chain.rs#L35) (où `XXX` est le nom de la variable) :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 22-26
:emphasize-lines: 2,5
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 28-44
:language: json
```

### Récupérer les N derniers blocs avec les détails des transactions

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 48-51
:emphasize-lines: 4
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 53-75
:language: json
```

### Récupérer les N derniers blocs avec les détails des transactions au format JSON

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 81-84
:emphasize-lines: 4
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 86-103
:language: json
```

Et en parsant les données JSON, on obtient ceci :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 107-126
:language: json
```

### Récupérer un ensemble de blocs

Exemple avec la récupération des blocs 10, 11 et 12 : la syntaxe est `[10, 12]`.

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 149-151
:emphasize-lines: 3
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 153-174
:language: json
```

### Récupérer les données JSON des transactions pour un bloc donné

Le bloc en question est le numéro 189314.

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 130-133
:emphasize-lines: 4
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 135-145
:language: json
```

### Récupérer toutes les données d’un bloc, détails des transactions inclus, pour un bloc donné

Le bloc en question est le numéro 189314.

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 198-201
:emphasize-lines: 4
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 203-244
:language: json
```

### Récupérer tout l’historique d’une adresse

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 289-290
:emphasize-lines: 2
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 292-325
:language: json
```

### Récupérer la balance et le nonce d’un compte

```{versionadded} 1.0.2
```

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 329
:language: shell
```

Output example:

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 331-334
:language: json
```

## 2️⃣ RPC

### Récupérer la liste des nœuds validateurs

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 178
:language: shell
```

Exemple de réponse :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 180-194
:language: json
```

## 3️⃣ RUES

[RUES](https://docs.dusk.network/developer/integrations/rues/) pour *Rusk Universal Event System* est un système permettant d’écouter la *blockchain* pour récupérer les évènements en temps réel.

Voici du code écrit en Python, et il est nécessaire d’installer les modules [requests](https://pypi.org/project/requests/) et [websockets](https://pypi.org/project/websockets/) avant d’aller plus loin.

### Lister les blocs validés par un nœud spécifique

```{literalinclude} snippets/node-dusk-http-wss.py
:caption: Fichier : listen.py
:language: python
```

Une fois le script en fonctionnement, les numéros de blocs générés par le nœud apparaitront en temps réel :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 247
:language: shell
```

Exemple de réponse brute (il s’agit du contenu de la variable `raw` dans le script) :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 249
```

Et une fois parsée, l’objet JSON suivant apparait (il s’agit du contenu de la variable `block` dans le script) :

```{literalinclude} snippets/node-dusk-http-wss.sh
:lines: 250-282
:language: json
```

## 📜 Historique

2025-02-14
:  Ajout de la section GraphQL [Récupérer la balance et le nonce d’un compte](#recuperer-la-balance-et-le-nonce-dun-compte) (rusk [`1.0.2`](https://github.com/dusk-network/rusk/releases/tag/dusk-rusk-1.1.0)).

2025-02-03
: Remplacement de l’argument `--data-raw` par `--json` pour les appels à `curl`.

2025-01-30
: Ajout de la section GraphQL [Lister les fonctions GraphQL disponibles et leurs structures de données](#lister-les-fonctions-graphql-disponibles-et-leurs-structures-de-donnees).
: Ajout de la section GraphQL [Récupérer tout l’historique d’une adresse](#recuperer-tout-l-historique-d-une-adresse).

2025-01-29
: Premier jet.
