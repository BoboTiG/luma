# [mainnet] Comment déployer un nœud Dusk ?

```{figure} images/dusk-logo.svg
:width: 96
:height: 96
:alt: Dusk Logo
:align: center

Site web : [dusk.network](https://dusk.network)
```

Ce guide est une traduction libre et légèrement modifiée de la [documentation officielle](https://docs.dusk.network/operator/guides/provisioner-node/) pour le déploiement d’un nœud Dusk, plus communément appelé *node provisioner*.

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

Rendez-vous sur le [wallet Dusk](https://apps.dusk.network/wallet/) pour créer un compte.

```{caution}
Bien garder les 12 mots de la *seed phrase* quelque part en sécurité.
```

---

## 🏪 Hébergement

La documentation officielle traite de Digital Ocean, et il est possible d’utiliser Hetzner ou encore [Vultr](https://www.vultr.com/?ref=9703379). Ici, nous parlerons de ce dernier.

Créé un compte sur [Vultr](https://www.vultr.com/?ref=9703379) et déployer un nouveau produit avec ces caractéristiques :

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

```{code-block} shell
:caption: 🖥️ Ordinateur (PC)

ssh dusk
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
:lines: 15-19
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

Ces commandes seront pratiques de déterminer l’état du nœud (ajuster la ligne surlignée avec les 16 premiers caractères de l’adresse publique du compte) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS) ✍️
:lines: 78-
:emphasize-lines: 4
:language: shell
```

Charger les commandes :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 76
:language: shell
```

### `accepted`

Affiche un décompte des lignes de *log* des blocs acceptés, c’est-à-dire quand le nœud a généré un bloc pris en compte par la *blockchain* (et qu’une récompense a été récupérée).

### `balance`

Affiche le nombre de DUSK disponible sur le *wallet*.

### `blocks`

Affiche l’avancée de synchronisation des blocs et les statistiques des blocs générés (utilisation implicite des alias [`generated`](#generated) et [`accepted`](#accepted)).

```{code-block}
:caption: 🔎 Exemple de sortie

[6965/6965] 60|30 (50.00%)
 ^-------------------------- dernier bloc synchronisé par le nœud
      ^--------------------- dernier bloc existant sur la blockchain
            ^--------------- nombre de blocs générés
               ^------------ nombre de blocs acceptés sur la blockchain
                   ^-------- ratio
```

### `generated`

Affiche un décompte des lignes de *log* des blocs générés.

### `logs`

Affiche les *logs* pour suivre l’avancée de la synchronisation du nœud.

### `rewards`

Connaître le montant des récompenses accumulées.

### `stake-info`

Affiche le nombre de *tokens* en *staking*.

---

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

```{caution}
À chaque fois que des *tokens* sont ajoutés en *staking*, le nœud sera incorporé à la *blockchain* **2 époques** plus tard, cette opération n’est pas immédiate.
```

### *Stake*

Pour l’exemple, plaçons 1 000 DUSK en *staking* (c’est le minimum requis) :

```{literalinclude} snippets/node-dusk.sh
:caption: ☁️ Serveur (VPS)
:lines: 37
:language: shell
```

```{astuce}
Plus il y a de *tokens* en *staking*, plus il y a de chances d’être sélectionné.
```

### *Stake More*

Une fois que des *tokens* sont en *staking*, il est possible d’en rajouter de deux manières.

#### Avec Pénalité

Augmenter le nombre de *tokens* "à la volée" donnera lieu à une pénalité (*soft slashing* en anglais) de 10% : soit 10% du montant sera bloqué et récupérable seulement quand la commande `unstake` sera utilisée.

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

1. Lorsque le nœud est sélectionné pour générer un bloc : récupération de 80% des *tokens* émis + une part variable suivant le nombre de voteurs inclus (non modifiable).
2. Lorsque le nœud est sélectionné en tant que voteur et inclus dans le bloc généré : récupération d’une fraction des *tokens* réservés aux voteurs.

Pour des informations techniques complètes, lire [Economic Protocol Design](https://github.com/dusk-network/audits/blob/main/core-audits/2024-09_protocol-security-review_oak-security.pdf) (section *Incentives goals*).

### *Slashing*

Le *slashing* est un système de protection qui pénalise les mauvais comportements. Quand ça [arrive](https://github.com/dusk-network/rusk/issues/1415) au nœud, une partie des récompenses est perdue, et s’il n’y en a pas, alors la participation au réseau est stoppée jusqu’à l’époque suivante.

---

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

---

## 🔗 Liens Utiles

- [Explorateur de blocs](https://apps.dusk.network/explorer/)

---

## 📜 Historique

```{admonition} Historique complet
:class: toggle

2025-01-05
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
: Ajout de la section [Récompenses](recompenses).
: Suppression de la section traitant du serveur NTP (obsolète depuis le passage à Vultr).

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
