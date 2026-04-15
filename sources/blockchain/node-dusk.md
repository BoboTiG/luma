# Comment déployer un nœud Dusk ?

```{figure} images/dusk-logo.svg
:width: 96
:height: 96
:alt: Dusk Logo
:align: center

Site web : [dusk.network](https://dusk.network)
```

Ce guide est une traduction libre et légèrement modifiée de la [documentation officielle](https://docs.dusk.network/operator/guides/provisioner-node/) pour le déploiement d’un nœud Dusk, plus communément appelé *node provisioner*.

````{tip}
```{code-block}
:caption: 🫶 Adresse Dusk pour les pourboires
VKZpBrNtEeTobMgYkkdcGiZn8fK2Ve2yez429yRXrH4nUUDTuvr7Tv74xFA2DKNVegtF6jaom2uacZMm8Z2Lg2J
```
````

## 🔗 Liens Utiles

- [Node Dashboard](https://github.com/BoboTiG/dusk-monitor)
- [Explorateur de blocs](https://apps.dusk.network/explorer/)
- [Run a Provisioner on Dusk](https://docs.dusk.network/operator/guides/provisioner-node/)
- [Economic Protocol Design](https://github.com/dusk-network/audits/blob/main/core-audits/2024-09_economic-protocol-design_pol-finance.pdf)
- [Staking on Dusk](https://docs.dusk.network/learn/guides/staking-basics/)
- [Slashing mechanism](https://docs.dusk.network/learn/deep-dive/slashing/)
- [Succinct Attestation Consensus](https://docs.dusk.network/learn/deep-dive/succinct-attestation/)

## ✅ [Configuration Requise](https://docs.dusk.network/operator/provisioner/#provisioner-specifications)

- Système d’exploitation : **Ubuntu 24.04**
- Architecture : x86-64
- Espace disque : 50 Gio NVMe
- Mémoire : 4 Gio de RAM

## 🪧 Avant-propos

```{include} _node-avant-propos.md
```

## 🪪 Créer un Compte

Rendez-vous sur le [wallet Dusk](https://apps.dusk.network/wallet/) pour créer un compte.

```{caution}
Bien garder les 12 mots de la *seed phrase* quelque part en sécurité.
```

## 🏪 Hébergement

La documentation officielle traite de Digital Ocean, et il est possible d’utiliser Hetzner ou encore [Vultr](https://www.vultr.com/?ref=9703380-9J). Ici, nous parlerons de ce dernier.

Créé un compte sur [Vultr](https://www.vultr.com/?ref=9703380-9J) et déployer un nouveau produit avec ces caractéristiques :

- Type : {menuselection}`Shared CPU --> High Performance --> vhp-2c-4gb-intel` (Intel, 2 vCPU, 4 GB RAM, 100 GB NVMe)
- *Location* : selon les préférences
- *Operating System*: Ubuntu 24.04 x64

### Configuration SSH

Lorsque le serveur sera opérationnel et que son adresse IP sera connue, configurons l’accès SSH sur le PC (remplacer `ADRESSE_IP` par l’adresse IP du serveur) :

```{literalinclude} snippets/node-dusk.sh
:caption: 🖥️ Ordinateur (PC) ✍️
:lines: 3-8
:language: shell
:emphasize-lines: 4
```

### Connexion

Se connecter en SSH au serveur (utiliser le mot de passe fourni sur Vultr) :

```{code-block} console
:caption: 🖥️ Ordinateur (PC)

$ ssh dusk
```

````{important}
Il est vivement recommandé de désactiver l’accès SSH par mot de passe pour favoriser l’utilisation d’une clé.
Un mini guide est disponible ici : [Comment paramétrer SSH pour un accès par clé](<../linux/parametrer-ssh-cle.md>).

```{code-block}
 _______             .___       ________               __
 \      \   ____   __| _/____   \______ \  __ __ _____|  | __
 /   |   \ /  _ \ / __ _/ __ \   |    |  \|  |  /  ___|  |/ /
/    |    (  <_> / /_/ \  ___/   |    `   |  |  \___ \|    <
\____|__  /\____/\____ |\___  > /_______  |____/____  |__|_ \
        \/            \/    \/          \/          \/     \/
```
````

## 🛠️ Installation

### Mise à Jour

Mettre à jour le système d’exploitation, puis redémarrer :

```{literalinclude} snippets/_node-os-upgrade.sh
:caption: ☁️ Serveur (VPS)
:lines: 2-7
:language: shell
```

Patienter quelques secondes et se [reconnecter](#connexion) au serveur.

### Pare-feu

Installer et configurer le pare-feu pour autoriser **seulement** les connexions entrantes sur les ports SSH et du nœud :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 15-19
:language: shell
```

### Serveur NTP

```{include} _node-ntp.md
```

### 📍 Dusk

Télécharger et exécuter le script d’installation automatique pour Dusk :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 23
:language: shell
```

## 🎛️ Commandes

Ces commandes seront pratiques de déterminer l’état du nœud :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS) ✍️
:lines: 78-
:language: shell
```

Charger les commandes :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 76
:language: shell
```

### `balance`

Affiche le nombre de DUSK disponible sur le *wallet*.

### `logs`

Affiche les *logs* pour suivre l’avancée de la synchronisation du nœud.

### `rewards`

Connaître le montant des récompenses accumulées.

### `stake-info`

Affiche le nombre de *tokens* en *staking*.

### `ruskquery block-height`

Affiche le dernier bloc synchronisé.

### `ruskquery peers`

Affiche le nombre de connexions à d’autres nœuds.

## ⚙️ Configuration

### Mot de Passe

Stocker le mot de passe du *wallet* Dusk afin de ne plus avoir à la taper pour toutes les futures commandes `rusk-wallet …` ([source](https://github.com/dusk-network/wallet-cli/blob/v0.22.1/src/bin/README.md#headless-mode)) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS) ✍️
:emphasize-lines: 1
:lines: 55-56
:language: shell
```

Tester que le mot de passe est visible (il devrait s’afficher, suivi de "OK") :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 58-59
:language: shell
```

### Importer le Compte

```{attention}
Les 12 mots de la *seed phrase* doivent être entrés en **minuscule**, chacun **séparé par un espace**.
```

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 26
:language: shell
```

### Exporter les Clefs de Consensus

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 28-29
:language: shell
```

## 🚀 Exécution

Pour démarrer le nœud :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 32
:language: shell
```

## 🪙 Staking

C’est la dernière étape pour pouvoir créer des blocs et participer au réseau.

```{caution}
À chaque fois que des *tokens* sont ajoutés en *staking*, le nœud sera incorporé à la *blockchain* **2 époques** plus tard (c’est-à-dire [4 320](https://github.com/dusk-network/rusk/blob/dusk-rusk-1.6.0/core/src/stake.rs#L33) blocs), cette opération n’est pas immédiate.

Pendant cette période d’attente, il est toutefois possible d’augmenter le nombre de *tokens* en *staking* [sans pénalité](https://github.com/dusk-network/contracts/blob/144c6e0e26122663bdf7378c61a3e37213b80292/genesis/stake/src/state.rs#L183-L187).
```

### *Stake*

Pour l’exemple, plaçons 1 000 DUSK en *staking* (c’est le [minimum requis](https://github.com/dusk-network/rusk/blob/dusk-rusk-1.6.0/core/src/stake.rs#L46)) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 37
:language: shell
```

```{tip}
Plus il y a de *tokens* en *staking*, plus il y a de chances d’être sélectionné.
```

### *Stake More*

Une fois que des *tokens* sont en *staking*, il est possible d’en rajouter de deux manières.

#### Avec Pénalité

Augmenter le nombre de *tokens* "à la volée" donnera lieu à une pénalité (*soft slashing* en anglais) de [10%](https://github.com/dusk-network/contracts/blob/144c6e0e26122663bdf7378c61a3e37213b80292/genesis/stake/src/state.rs#L124-L128) : soit 10% du montant sera bloqué et récupérable seulement quand la commande `unstake` sera utilisée.

Voici la procédure pour *staker* plus de *tokens* avec *soft slashing* (remplacer `AMOUNT` par le nombre de *tokens*) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS) ✍️
:lines: 66
:language: shell
```

#### Sans Pénalité

Voici la procédure pour *staker* plus de *tokens* sans *soft slashing* (remplacer `AMOUNT` par le nombre de *tokens*) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS) ✍️
:lines: 67-68
:emphasize-lines: 2
:language: shell
```

### 💰 Récompenses

Il y a deux moyens de récupérer des récompenses :

1. Lorsque le nœud est sélectionné pour générer un bloc : récupération de 70% des *tokens* émis + une part variable suivant le nombre de voteurs inclus (non modifiable).
2. Lorsque le nœud est sélectionné en tant que voteur et inclus dans le bloc généré : récupération d’une fraction des 10% des *tokens* réservés aux voteurs.

Pour des informations techniques complètes, lire [Economic Protocol Design](https://github.com/dusk-network/audits/blob/main/core-audits/2024-09_economic-protocol-design_pol-finance.pdf) (section *Incentives goals*) et le [code source](https://github.com/dusk-network/rusk/blob/dusk-rusk-1.6.0/rusk/src/lib/node.rs#L126-L132).

```{caution}
Afin de pouvoir retirer ses récompenses, il faut qu’il y [ait des *tokens* en *staking*](https://github.com/dusk-network/contracts/blob/144c6e0e26122663bdf7378c61a3e37213b80292/genesis/stake/src/state.rs#L351)<sup><small>[à confirmer]</small></sup>.
```

La commande suivante permet de récupérer les récompenses (remplacer `AMOUNT` par le nombre de *tokens*, en option) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 35
:language: shell
```

### *Slashing*

Le *slashing* est un système de protection qui pénalise les mauvais comportements. Quand ça [arrive](https://github.com/dusk-network/rusk/issues/1415) au nœud, une partie des récompenses est perdue, et s’il n’y en a pas, alors la participation au réseau est stoppée jusqu’à l’époque suivante. Plus d’information sur [Slashing mechanism](https://docs.dusk.network/learn/deep-dive/slashing/).

## 🌡️ Supervision

Il existe plusieurs projets permettant de suivre l’état du nœud, voici celui que j'utilise : [BoboTiG/dusk-monitor](https://github.com/BoboTiG/dusk-monitor).

## 🐛 Débogage

Section pour les cas où le système ne fonctionne pas comme prévu.

### *Block Mode Error*

Relancer la commande pour [exporter les clefs de consensus](#exporter-les-clefs-de-consensus).

### Repartir de Zéro

Si nécessaire, repartir de zéro :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 72-74
:language: shell
```

### Règles du Pare-feu

Liste des règles actives :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 53
:language: shell
```

Voici la sortie attendue :

```{code-block}
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     LIMIT IN    Anywhere
9000/udp                   ALLOW IN    Anywhere
22/tcp (v6)                LIMIT IN    Anywhere (v6)
9000/udp (v6)              ALLOW IN    Anywhere (v6)
```

### Avertissements dans les logs

Pour les trouver, utiliser cette commande :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 30
:language: shell
```

Avertissements connus :

1. Cet avertissement n’est pas important et peut être ignoré :

   ```{code-block}
   2025-01-22T23:07:33.710209Z  WARN node::databroker: error on handling msg: could not find locator block
   ```

2. Peut être ignoré si exceptionnel. Cela veut dire que le nœud a temporairement pris du retard dans la synchronisation. Peut donner lieu à un *[soft slash](#slashing)* si le nœud est sélectionné tout en état en retard à plusieurs reprises :

   ```{code-block}
   2025-01-22T23:26:14.069521Z  WARN node::chain::acceptor: event="missed iteration" height=133665 iter=0 generator="REDACTED"
   ```

### Erreurs dans les logs

Pour les trouver, utiliser cette commande :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 31
:language: shell
```

Erreurs connues :

1. Cette erreur n’est pas importante et peut être ignorée :

   ```{code-block}
   2025-01-13T11:01:23.140197Z ERROR kadcast::handling: Invalid Id Header { binary_id: BinaryID { bytes: [173, 236, 205, 149, 2, 31, 24, 69, 160, 37, 18, 19, 190, 133, 175, 232], nonce: [118, 0, 0, 0] }, sender_port: 9000, network_id: 1, reserved: [0, 0] } - from REDACTED
   ```

2. Cette erreur n’est pas importante et peut être ignorée (elle sera bientôt de l’[histoire ancienne](https://github.com/dusk-network/rusk/issues/3478)) :

   ```{code-block}
   2025-01-22T00:13:52.189187Z ERROR main{round=125324 iter=0 name=Ratification pk="REDACTED"}: dusk_consensus::execution_ctx: phase handler err: VoteAlreadyCollected
   ```

## 📜 Historique

```{admonition} Historique complet
:class: toggle

2026-04-15
: Utilisation de la commande `claim-rewards` à la place de `withdraw` (dépréciée) pour récupérer les récompenses.
: Mise à jour de la version de `rusk` (`1.0.0` → `1.6.0`) pour les liens pointant vers du code source.

2025-02-22
: Mise à jour définitive de la version du script d’installation de Dusk (`0.5.4` → `latest`).

2025-02-14
: Mise à jour de la version du script d’installation de Dusk (`0.5.3` → `0.5.4`).

2025-01-23
: Correction des chiffres liés aux [récompenses](#recompenses).
: Suppression des alias `blocks` et `generated`. Ils n’étaient plus vraiment pertinents depuis l’arrivée des outils de [supervision](#supervision) ([f03701d](https://github.com/BoboTiG/luma/commit/f03701d6ffe047f7939d30595a558db45f261841)).
: Ajout des commandes [`ruskquery block-height`](#ruskquery-block-height) et [`ruskquery peers`](#ruskquery-peers).
: Ajout de la section [Avertissements dans les logs](#avertissements-dans-les-logs).
: Ajout de la section [Erreurs dans les logs](#erreurs-dans-les-logs).

2025-01-11
: Ajout de la section [Supervision](#supervision).
: Correction du code de l’alias [generated](#generated) pour trier correctement les fichiers de log.

2025-01-08
: Suppression de l’alias `accepted`. La notion de blocs générés versus blocs acceptés était erronée, il n’y a en réalité que des blocs générés. Dans le cas ou le bloc généré est à une itération supérieure à zéro, il s’agit d’une action permettant de proposer un bloc quand l’autre nœud sélectionné n’arriverait pas à fournir le bloc à temps.
: Simplification des alias `blocks` et `generated`.
: Amélioration de l’alias `generated` pour trier par numéro de bloc.

2025-01-05
: Mise à jour de la version du script d’installation de Dusk (`0.5.2` → `0.5.3`) pour le *kick-off* du *mainnet* !
: Ajout des alias [`accepted`](#accepted) et [`generated`](#generated).
: L’alias `blocks` affiche désormais toutes les informations utiles pour connaître les statisriques du nœud.
: Suppression des alias `chosen`, `current` et `latest`.

2025-01-04
: Ajout de la section [*Stake More*](#stake-more).

2025-01-03
: Mise à jour de la version du script d’installation de Dusk (`0.5.1` → `0.5.2`) pour le second *dry-run* du *mainnet*.
: Suppression de l’ouverture du port 8080/TCP (utile seulement pour les nœuds de type *archive*).
: Simplification de l’alias `latest`.

2025-01-02
: L’alias `latest` utilise désormais une requête HTTP vers l’URL officielle du nœud plutôt que le nœud local ([59d594e](https://github.com/BoboTiG/luma/commit/59d594e9bc1e2ccdbd4023ba48e366ec174884e4)).

2025-01-01
: Changement d’hébergeur pour cause de mauvaises performances (Contabo → Vultr).
: Ajout de la section [Récompenses](#recompenses).

2024-12-30
: Amélioration de l’alias `chosen` ([0907b14](https://github.com/BoboTiG/luma/commit/0907b1467c25a6e88ede070f3de3bef324d5ddec) → [53f84d7](https://github.com/BoboTiG/luma/commit/53f84d74bbfc1f6313ec58914f5af497cea9cb1f)).

2024-12-28
: Mise à jour de la version du script d’installation de Dusk (`0.5.0` → `0.5.1`).
: Simplification de la commande d’installation de Dusk.

2024-12-27
: Mise à jour de la version du script d’installation de Dusk (`0.4.0` → `0.5.0`) pour la migration depuis le *testnet* "Nocturne" vers le premier *dry-run* du *mainnet*.
: Correction de la commande d’installation de Dusk (`sh` → `bash`).
: Suppression du lien vers le fausset du *testnet*.

2024-12-15
: Ajout de l’avertissement quant à l’utilisation d’un mot de passe pour accéder au serveur via SSH.

2024-12-12
: Mise à jour de la version du script d’installation de Dusk (`0.3.5` → `0.4.0`).
: Changement du système d’exploitation du serveur VPS pour supporter la nouvelle version de Dusk (`Debian 12` → `Ubuntu 24.04`).

2024-10-21
: Mise à jour de la version du script d’installation de Dusk (`0.3.2` → `0.3.5`).
: Correction du lien vers le fausset (`https://docs.dusk.network/itn/testnet-faucet/` → `https://docs.dusk.network/operator/nocturne/testnet-faucet/`).

2024-10-10
: Simplification de la commande pour [Repartir de Zéro](#repartir-de-zero).
: Mise à jour de la version du script d’installation de Dusk (`0.2.0` → `0.3.2`).

2024-03-25
: Mise à jour de la version du script d’installation de Dusk (`0.1.9` → `0.2.0`) pour la migration depuis l’ITN vers le *testnet* "Nocturne".

2024-03-16
: Mise à jour de la version du script d’installation de Dusk (`0.1.8` → `0.1.9`).

2024-03-13
: Tri alphabétique des [commandes](#commandes).
: Mise à jour de la version du script d’installation de Dusk (`0.1.7` → `0.1.8`).

2024-03-08
: Amélioration de la commande [`chosen`](#chosen) pour prendre en compte les fichiers de *log* archivés.

2024-03-06
: Ajout de la section [Commandes](#commandes).
: Mise à jour de la version du script d’installation de Dusk (`0.1.6` → `0.1.7`).

2024-03-03
: Installation de `unattended-upgrades` pour garder le système d’exploitation à jour et réduire le temps de maintenance.

2024-01-02
: Mise à jour de la version du script d’installation de Dusk (`0.1.5` → `0.1.6`).
: Changement de région pour le serveur (*European Union (Germany)* → *United Kingdom*) pour pallier les soucis de DNS.

2024-02-29
: Mise à jour de la version du script d’installation de Dusk (`0.1.4` → `0.1.5`).

2024-02-22
: Mise à jour de la version du script d’installation de Dusk (`0.1.2` → `0.1.3`).
: Mise à jour de la version du script d’installation de Dusk (`0.1.3` → `0.1.4`).

2024-02-21
: Mise à jour de la version du script d’installation de Dusk (`0.1.1` → `0.1.2`).

2024-02-19
: Mise à jour de la version du script d’installation de Dusk (`0.1.0` → `0.1.1`).

2024-02-17
: Règle SSH du pare-feu plus protectrice.

2024-02-16
: Premier jet.
```
