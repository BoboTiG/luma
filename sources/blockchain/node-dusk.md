# [mainnet] Comment déployer un nœud Dusk ?

```{figure} images/dusk-logo.svg
:width: 96
:height: 96
:alt: Dusk Logo
:align: center

Site web : [dusk.network](https://dusk.network)
```

Ce guide est une traduction libre et légèrement modifiée de la [documentation officielle](https://docs.dusk.network/operator/guides/mainnet-node/) pour le déploiement d’un nœud Dusk, plus communément appelé *node provisioner*.

## ✅ [Configuration Requise](https://docs.dusk.network/operator/provisioner/#provisioner-specifications)

- Système d’exploitation : **Ubuntu 24.04**
- Architecture : x86-64
- Espace disque : 50 Gio NVMe
- Mémoire : 4 Gio de RAM

---

## 🪧 Avant-propos

```{include} _node-avant-propos.md
```

---

## 🪪 Créer un Compte

Rendez-vous sur le [wallet Dusk](https://wallet.dusk.network) pour créer un compte.

```{caution}
Bien garder les 12 mots de la *seed phrase* quelque part en sécurité.
```

---

## 🏪 Hébergement

La documentation officielle traite de Digital Ocean, et il est possible d'utiliser Hetzner ou encore [Vultr](https://www.vultr.com/?ref=9703379). Ici, nous parlerons de ce dernier.

Créé un compte sur [Vultr](https://www.vultr.com/?ref=9703379) et déployer un nouveau produit avec ces caractéristiques :

- Type : {menuselection}`Shared CPU --> High Performance --> vhp-2c-4gb` (2 vCPU, 4 GB RAM, 100 GB NVMe)
- *Location* : selon les préférences, j'ai opté pour {menuselection}`Europe --> Amsterdam`
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

Se connecter en SSH au serveur (utiliser le mot de passe défini sur Contabo) :

```{code-block} shell
:caption: 🖥️ Ordinateur (PC)

ssh dusk
```

```{important}
Il est vivement recommandé de désactiver l’accès SSH par mot de passe pour favoriser l’utilisation d’une clé.
Un mini guide est disponible ici : [Comment paramétrer SSH pour un accès par clé](<../linux/parametrer-ssh-cle.md>).
```

---

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
:lines: 15-20
:language: shell
```

### 📍 Dusk

Télécharger et exécuter le script d’installation automatique pour Dusk :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 23
:language: shell
```

---

## 🎛️ Commandes

Ces commandes seront pratiques plus tard afin de déterminer l’état du nœud :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 72-83
:language: shell
```

Charger les commandes :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 84
:language: shell
```

### `balance`

Affiche le nombre de DUSK disponible sur le *wallet*.

### `blocks`

Affiche le résultat des commandes [`latest`](#latest) et [`current`](#current).

### `chosen`

Lorsque le nœud est à jour, que les *tokens* sont en *staking* et qu’au minimum 2 époques sont passées, cette commande permet de voir quand le nœud est sélectionné pour créer un bloc.

### `current`

Cette commande renvoie le dernier bloc de la *blockchain*.

### `latest`

Retourne le dernier bloc synchronisé par le nœud.

### `logs`

Affiche les *logs* pour suivre l’avancée de la synchronisation du nœud.

### `rewards`

Connaître le montant des récompenses accumulées.

### `stake-info`

Affiche le nombre de *tokens* en *staking*.

---

## ⚙️ Configuration

### Mot de Passe

Stocker le mot de passe du *wallet* Dusk afin de ne plus avoir à la taper pour toutes les futures commandes `rusk-wallet …` ([source](https://github.com/dusk-network/wallet-cli/blob/v0.21.0/src/bin/README.md#headless-mode)) :

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

---

## 🚀 Exécution

Pour démarrer le nœud :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 32
:language: shell
```

---

## 🪙 Staking

C’est la dernière étape pour pouvoir créer des blocs et participer au réseau.

### *Stake*

Pour l’exemple, plaçons 1 000 DUSK en *staking* (c’est le minimum requis) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 37
:language: shell
```

````{admonition} Exemple de sortie
:class: toggle

```{code-block}
✔ Please enter wallet password: · [hidden]
2024-02-16T06:42:38.853692Z  INFO rusk_wallet::io::status: status="Opening notes database"
2024-02-16T06:42:39.410372Z  INFO rusk_wallet::io::status: status="Getting cached note position..."
2024-02-16T06:42:39.410540Z  INFO rusk_wallet::io::status: status="Fetching fresh notes..."
2024-02-16T06:42:39.486784Z  INFO rusk_wallet::io::status: status="Connection established..."
2024-02-16T06:42:39.490624Z  INFO rusk_wallet::io::status: status="Streaming notes..."
2024-02-16T06:42:40.226524Z  INFO rusk_wallet::io::status: status="Fetching stake..."
2024-02-16T06:42:40.294510Z  INFO rusk_wallet::io::status: status="Stake received!"
Staking address: [REDACTED]
2024-02-16T06:42:40.298475Z  INFO rusk_wallet::io::status: status="Requesting stct proof..."
2024-02-16T06:42:45.970020Z  INFO rusk_wallet::io::status: status="Stct proof success!"
2024-02-16T06:42:45.974639Z  INFO rusk_wallet::io::status: status="Fetching opening notes..."
2024-02-16T06:42:47.099239Z  INFO rusk_wallet::io::status: status="Opening notes received!"
2024-02-16T06:42:47.099421Z  INFO rusk_wallet::io::status: status="Fetching anchor..."
2024-02-16T06:42:47.204651Z  INFO rusk_wallet::io::status: status="Anchor received!"
2024-02-16T06:42:47.227090Z  INFO rusk_wallet::io::status: status="Proving tx, please wait..."
2024-02-16T06:43:08.214350Z  INFO rusk_wallet::io::status: status="Proof success!"
2024-02-16T06:43:08.219467Z  INFO rusk_wallet::io::status: status="Attempt to preverify tx..."
2024-02-16T06:43:08.427675Z  INFO rusk_wallet::io::status: status="Preverify success!"
2024-02-16T06:43:08.427721Z  INFO rusk_wallet::io::status: status="Propagating tx..."
2024-02-16T06:43:08.527562Z  INFO rusk_wallet::io::status: status="Transaction propagated!"
2024-02-16T06:43:08.597338Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (1/30)"
2024-02-16T06:43:09.685356Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (2/30)"
2024-02-16T06:43:10.810684Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (3/30)"
2024-02-16T06:43:11.896795Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (4/30)"
2024-02-16T06:43:13.002293Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (5/30)"
[TRANSACTION HASH REDACTED]
```
````

````{caution}
La commande précédente **ne peut pas** être utilisée à plusieurs reprises pour augmenter le nombre de *tokens* à *staker*.

Voici la procédure pour *staker* plus de *tokens* (remplacer `AMOUNT` par le nombre de *tokens*) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS) ✍️
:lines: 67-68
:emphasize-lines: 2
:language: shell
```
````

```{astuce}
Plus il y a de *tokens* en *staking*, plus il y a de chances d’être sélectionné.
```

### 💰 Récompenses

Il y a deux moyens de récupérer des récompenses :

1. Lorsque le nœud est sélectionné pour générer un bloc : récupération de 80% des *tokens* émis + une part variable suivant le nombre de voteurs inclus (non modifiable).
2. Lorsque le nœud est sélectionné en tant que voteur et inclus dans le bloc généré : récupération d'une fraction des *tokens* réservés aux voteurs.

Pour des informations techniques complètes, lire [Economic Protocol Design](https://github.com/dusk-network/audits/blob/main/core-audits/2024-09_protocol-security-review_oak-security.pdf) (section *Incentives goals*).

### *Slashing*

Le *slashing* est un système de protection qui pénalise les mauvais comportements. Quand ça [arrive](https://github.com/dusk-network/rusk/issues/1415) au nœud, une partie des récompenses est perdue, et s’il n’y en a pas, alors la participation au réseau est stoppée jusqu’à l’époque suivante.

#### Raisons

Dans l’immédiat, la seule raison connue est quand un pair trouve que le nœud a mis trop de temps pour valider un bloc. Il n’y a rien à faire pour éviter ça, juste espérer qu’avoir un [serveur NTP](#serveur-ntp) performant aide à prévenir cela.

---

## 🐛 Débogage

Section pour les cas où le système ne fonctionne pas comme prévu.

### *Block Mode Error*

Relancer la commande pour [exporter les clefs de consensus](#exporter-les-clefs-de-consensus).

### Repartir de Zéro

Si nécessaire, repartir de zéro :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 86-88
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
8080/tcp                   ALLOW IN    Anywhere
9000/udp                   ALLOW IN    Anywhere
22/tcp (v6)                LIMIT IN    Anywhere (v6)
8080/tcp (v6)              ALLOW IN    Anywhere (v6)
9000/udp (v6)              ALLOW IN    Anywhere (v6)
```

Liste des ports réellement ouverts :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 52
:language: shell
```

````{admonition} Exemple de sortie
:class: toggle

```{code-block}
:emphasize-lines: 8-9

COMMAND   PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sshd      530    root    3u  IPv4   2288      0t0  TCP *:22 (LISTEN)
sshd      530    root    4u  IPv6   2290      0t0  TCP *:22 (LISTEN)
chronyd 37323 _chrony    5u  IPv4 264489      0t0  UDP 127.0.0.1:323
chronyd 37323 _chrony    6u  IPv6 264490      0t0  UDP [::1]:323
rusk    38995    dusk   23u  IPv4 269825      0t0  UDP *:46317
rusk    38995    dusk   24u  IPv6 269826      0t0  UDP *:41981
rusk    38995    dusk   25u  IPv4 269827      0t0  UDP ADRESSE_IP:9000
rusk    38995    dusk   27u  IPv4 269831      0t0  TCP 127.0.0.1:8080 (LISTEN)
```
````

---

## 🔗 Liens Utiles

- [Explorateur de blocs](https://apps.dusk.network/explorer/)

---

## 📜 Historique

```{admonition} Historique complet
:class: toggle

2025-01-01
: Changement d'hébergeur pour cause de mauvaises performances (Contabo → Vultr).
: Ajout de la section [Récompenses](recompenses).
: Suppression de la section traitant du serveur NTP (obsolète depuis le passage à Vultr).

2024-12-30
: Amélioration de l’alias `chosen` ([0907b14](https://github.com/BoboTiG/luma/commit/0907b1467c25a6e88ede070f3de3bef324d5ddec) → [53f84d7](https://github.com/BoboTiG/luma/commit/53f84d74bbfc1f6313ec58914f5af497cea9cb1f)).

2024-12-28
: Mise à jour de la version du script d’installation de Dusk (`0.5.0` → `0.5.1`).
: Simplification de la commande d’installation de Dusk.

2024-12-27
: Mise à jour de la version du script d’installation de Dusk (`0.4.0` → `0.5.0`) pour la migration depuis le *testnet* "Nocturne" vers le *mainnet*.
: Adaptation du lien vers la documentation (`https://docs.dusk.network/itn/node-running-guide` → `https://docs.dusk.network/operator/guides/mainnet-node/`).
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
: Ajout de la section [commandes](#commandes).
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
